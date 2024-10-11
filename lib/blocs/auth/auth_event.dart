part of 'auth_bloc.dart';

sealed class AuthEvent {}

class InitialFetchLoginDataEvent extends AuthEvent{}

//!Login
class LoginEvent extends AuthEvent{
  final String email, password;

  LoginEvent({required this.email, required this.password});
}

//!Logout
class LogoutEvent extends AuthEvent{}

//!Forgot Password
class SendOTPEvent extends AuthEvent{
  final String email;

  SendOTPEvent({required this.email});
}

class VerifyOTPEvent extends AuthEvent{
  final String email, otp;

  VerifyOTPEvent({required this.email, required this.otp});
}

class ResetPasswordEvent extends AuthEvent{
  final String password;

  ResetPasswordEvent({required this.password});
}