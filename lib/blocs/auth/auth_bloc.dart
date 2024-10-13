import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../configs/app_constants.dart';
import '../../database/local_db.dart';
import '../../models/model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? email, password, token, name, phone;
  LoginModel? loginModel;
  ResponseModel? responseModel;

  AuthBloc() : super(PreviousLoginInitial()) {
    on<InitialFetchLoginDataEvent>(initialFetchLoginDataEvent);
    on<LoginEvent>(loginEvent);
    on<SignUpEvent>(signUpEvent);
    on<LogoutEvent>(logoutEvent);
    on<PasswordResetEvent>(passwordResetEvent);
  }

  FutureOr<void> initialFetchLoginDataEvent(
      InitialFetchLoginDataEvent event, Emitter<AuthState> emit) async {
    try {
      final myData = await LocalDB.getLoginInfo();
      if (myData == null || myData[0].isEmpty || myData[1].isEmpty) {
        emit(NoPreviousDataState());
      } else {
        logger.f("message myData: ${myData.length}");
        email = myData[0];
        password = myData[1];

        await _handleSignIn(
          email: email!,
          password: password!,
          onSuccess: () => emit(AuthSuccessState()),
          onError: (message) => emit(AuthErrorState(errorMessage: message)),
        );
      }
    } catch (e) {
      logger.e("Error during fetch login data: $e");
      emit(PreviousAuthErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      await _handleSignIn(
        email: event.email,
        password: event.password,
        onSuccess: () {
          emit(AuthSuccessState());
          LocalDB.postLoginInfo(email: event.email, password: event.password);
        },
        onError: (message) => emit(AuthErrorState(errorMessage: message)),
      );
    } catch (e) {
      logger.e("Login error: $e");
      emit(AuthErrorState(errorMessage: "Login failed. Please try again."));
    }
  }

  Future<void> _handleSignIn({
    required String email,
    required String password,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Connection timed out. Please try again.");
      });

      if (userCredential.user != null) {
        logger.i("Logged in: ${userCredential.user?.email} ${userCredential.user?.displayName}");
        onSuccess();
      } else {
        onError("Login failed. Please try again.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
        onError("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        logger.e('Wrong password provided for that user.');
        onError("Wrong password provided for that user.");
      } else {
        // Log all other FirebaseAuthException cases
        logger.e("FirebaseAuthException: ${e.message}");
        onError("An error occurred: ${e.message}");
      }
    } on TimeoutException catch (_) {
      logger.e("Login timeout.");
      onError("Login timeout. Please check your internet connection.");
    } catch (e) {
      // Log and catch all other exceptions
      logger.e("Unknown error occurred: $e");
      onError("An unknown error occurred. Please try again.");
    }
  }


  Future<void> signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Connection timed out. Please try again.");
      });

      if (userCredential.user != null) {
        emit(AuthSuccessState());
        LocalDB.postLoginInfo(email: event.email, password: event.password);
      } else {
        emit(AuthErrorState(errorMessage: "Something went wrong"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.e('The password provided is too weak.');
        emit(AuthErrorState(errorMessage: "The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        logger.e('The account already exists for that email.');
        emit(AuthErrorState(errorMessage: "The account already exists for that email."));
      }
    } on TimeoutException catch (_) {
      emit(AuthErrorState(errorMessage: "Sign-up timeout. Please try again."));
    } catch (e) {
      logger.e(e);
      emit(AuthErrorState(errorMessage: "An error occurred: $e"));
    }
  }

  FutureOr<void> logoutEvent(LogoutEvent event, Emitter<AuthState> emit) {
    try {
      LocalDB.delLoginInfo();
      emit(LogoutSuccessState());
    } catch (e) {
      emit(LogoutFailedState());
    }
  }
  Future<void> passwordResetEvent(PasswordResetEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState()); // Optional: Emit loading state if needed
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      logger.i("Password reset email sent successfully");
      emit(PasswordResetSuccessState());
    } on FirebaseAuthException catch (e) {
      logger.e("Error sending password reset email: ${e.message}");
      if (e.code == 'user-not-found') {
        emit(PasswordResetErrorState(errorMessage: "No user found for that email."));
      } else {
        emit(PasswordResetErrorState(errorMessage: "Failed to send password reset email. Please try again."));
      }
    } catch (e) {
      logger.e("Unknown error occurred: $e");
      emit(PasswordResetErrorState(errorMessage: "An unknown error occurred. Please try again."));
    }
  }
}
