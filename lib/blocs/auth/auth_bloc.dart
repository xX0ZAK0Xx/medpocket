import 'dart:async';

import 'package:bloc/bloc.dart';
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
      
    } catch (e) {
      // Log and catch all other exceptions
      logger.e("Unknown error occurred: $e");
      onError("An unknown error occurred. Please try again.");
    }
  }


  Future<void> signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
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

    } catch (e) {
      logger.e("Unknown error occurred: $e");
      emit(PasswordResetErrorState(errorMessage: "An unknown error occurred. Please try again."));
    }
  }
}
