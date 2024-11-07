import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:medpocket/repositories/post_response.dart';
import '../../configs/app_constants.dart';
import '../../configs/app_urls.dart';
import '../../database/local_db.dart';
import '../../models/model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? email, password, token, name, phone;
  AuthModel? authModel;
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
        final payload = {
        "email": email,
        "password": password
        };
        final res = await postResponse(url: AppUrls.login, payload: payload);
        final AuthModel authModel = await Isolate.run(() =>  authModelFromJson(res));
        if(authModel.success == true) {
          emit(AuthSuccessState(allDone: authModel.data?.allSetup??false));
          LocalDB.setId(id: authModel.data?.id??"");
        }else{
          emit(PreviousAuthErrorState(errorMessage: authModel.message??""));
        }
      }
    } catch (e) {
      logger.e("Error during fetch login data: $e");
      emit(PreviousAuthErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final payload = {
        "email": event.email,
        "password": event.password
      };
      final res = await postResponse(url: AppUrls.login, payload: payload);
      final AuthModel authModel = await Isolate.run(() =>  authModelFromJson(res));
      if(authModel.success == true) {
        emit(AuthSuccessState(allDone: authModel.data?.allSetup??false));
        LocalDB.postLoginInfo(email: event.email, password: event.password);
        LocalDB.setId(id: authModel.data?.id??"");
      }else{
        emit(AuthErrorState(errorMessage: authModel.message??""));
      }
    } catch (e) {
      logger.e("Login error: $e");
      emit(AuthErrorState(errorMessage: "Login failed. Please try again."));
    }
  }

  


  Future<void> signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final payload = {
        "email": event.email,
        "password": event.password,
      };
      final res = await postResponse(url: AppUrls.signup, payload: payload);
      final AuthModel authModel = await Isolate.run(() =>  authModelFromJson(res));
      if(authModel.success == true) {
        emit(AuthSuccessState(allDone: false));
        LocalDB.postLoginInfo(email: event.email, password: event.password);
      }else{
        emit(AuthErrorState(errorMessage: authModel.message??""));
      }
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
    //   await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
    //   logger.i("Password reset email sent successfully");
    //   emit(PasswordResetSuccessState());
    // } on FirebaseAuthException catch (e) {
    //   logger.e("Error sending password reset email: ${e.message}");
    //   if (e.code == 'user-not-found') {
    //     emit(PasswordResetErrorState(errorMessage: "No user found for that email."));
    //   } else {
    //     emit(PasswordResetErrorState(errorMessage: "Failed to send password reset email. Please try again."));
    //   }
    } catch (e) {
      logger.e("Unknown error occurred: $e");
      emit(PasswordResetErrorState(errorMessage: "An unknown error occurred. Please try again."));
    }
  }
}
