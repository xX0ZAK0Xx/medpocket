import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:medpocket/configs/app_urls.dart';
import 'package:medpocket/repositories/post_response.dart';

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
    //?Login Logout
    on<InitialFetchLoginDataEvent>(initialFetchLoginDataEvent);
    on<LoginEvent>(loginEvent);
    on<LogoutEvent>(logoutEvent);

    //?Forgot Password
    on<SendOTPEvent>(sendOTPEvent);
    on<VerifyOTPEvent>(verifyOTPEvent);
    on<ResetPasswordEvent>(resetPasswordEvent);
  }

  FutureOr<void> initialFetchLoginDataEvent(InitialFetchLoginDataEvent event, Emitter<AuthState> emit) async {
    try {
      final myData = await LocalDB.getLoginInfo();
      if (myData == null || myData[0] == "" || myData[1] == "") {
        emit(NoPreviousDataState());
      } else {
        logger.f("message myData: ${myData.length}");
        email = myData[0];
        password = myData[1];
        token = myData[2];
        Map<String, String> payload = {
          "email": email??"",
          "password": password??""
        };
        final loginResponse = await postResponse(url: AppUrls.login, payload: payload);
        loginModel = loginModelFromJson(loginResponse);

        await Future.delayed(const Duration(seconds: 1));

        if(loginModel?.success == true) {
          emit(LoginSuccessState());
        }else{
          emit(PreviousAuthErrorState(errorMessage: loginModel?.message??""));
        }
      }
    } catch (e) {
      logger.e("Error during fetch login data: $e");
      emit(PreviousAuthErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    Map<String, String> payload = {
      "email": event.email,
      "password": event.password
    };
    try {
      final loginResponse = await postResponse(url: AppUrls.login, payload: payload);
      loginModel = loginModelFromJson(loginResponse);

      if(loginModel?.success == true) {
        LocalDB.postLoginInfo(email: event.email, password: event.password, token: loginModel?.token??"");
        emit(LoginSuccessState());
      }else{
        emit(AuthErrorState(errorMessage: loginModel?.message??""));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
      logger.e(e);
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

  FutureOr<void> sendOTPEvent(SendOTPEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    Map<String, String> payload = {
      "email": event.email,
      "type":"reset_btob"
    };
    try {
      final sendOtpResponse = await postResponse(url: AppUrls.sendOtp, payload: payload);
      final ResponseModel responseModel = responseModelFromJson(sendOtpResponse);
      if(responseModel.success == true) {
        emit(SentOtpSuccessState());
      }else{
        emit(SentOtpFailedState(errorMessage: responseModel.message??"Something Went Wrong"));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
      logger.e(e);
    }
  }

  FutureOr<void> verifyOTPEvent(VerifyOTPEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    Map<String, String> payload = {
      "email": event.email,
      "otp": event.otp,
      "type":"reset_btob"
    };
    try {
      final verifyOtpResponse = await postResponse(url: AppUrls.verifyOtp, payload: payload);
      responseModel = responseModelFromJson(verifyOtpResponse);
      if(responseModel?.success == true) {
        emit(VerifyOtpSuccessState());
      }else{
        emit(VerifyOtpFailedState(errorMessage: responseModel?.message??"Something went wrong"));
      }
    } catch (e) {
      emit(VerifyOtpFailedState(errorMessage: e.toString()));
      logger.e(e);
    }
  }

  FutureOr<void> resetPasswordEvent(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    Map<String, String> payload = {
      "token": responseModel?.token??"",
      "password": event.password,
    };
    try {
      final resetPassResponse = await postResponse(url: AppUrls.resetPassword, payload: payload);
      ResponseModel responseModel = responseModelFromJson(resetPassResponse);
      if(responseModel.success == true) {
        emit(ResetPassSuccessState());
      }else{
        emit(ResetPassFailedState(errorMessage: responseModel.message??"Something went wrong"));
      }
    } catch (e) {
      emit(ResetPassFailedState(errorMessage: e.toString()));
      logger.e(e);
    }
  }
}