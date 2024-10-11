part of 'auth_bloc.dart';

sealed class AuthEvent {}

class InitialFetchLoginDataEvent extends AuthEvent{}

//!Login
class LoginEvent extends AuthEvent{
  final String email, password;

  LoginEvent({required this.email, required this.password});
}
//!SignUp
class SignUpEvent extends AuthEvent{
  final String email, password;

  SignUpEvent({required this.email, required this.password});
}

//!Logout
class LogoutEvent extends AuthEvent{}

//!Forgot Password
class PasswordResetEvent extends AuthEvent {
  final String email;

  PasswordResetEvent({required this.email});
}