part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthActionState extends AuthState {}
//?Database Login
final class PreviousLoginInitial extends AuthState {}
final class NoPreviousDataState extends AuthState {}
final class PreviousAuthErrorState extends AuthActionState {
  final String errorMessage;

  PreviousAuthErrorState({required this.errorMessage });
}


//?Normal Login
final class AuthLoadingState extends AuthActionState {}
final class LoginSuccessState extends AuthActionState {}
final class AuthErrorState extends AuthActionState {
  final String errorMessage;

  AuthErrorState({required this.errorMessage });
}


//? OTP
final class SentOtpSuccessState extends AuthActionState {}
final class SentOtpFailedState extends AuthActionState {
  final String errorMessage;
  SentOtpFailedState({required this.errorMessage});
}

final class VerifyOtpSuccessState extends AuthActionState {}
final class VerifyOtpFailedState extends AuthActionState {
  final String errorMessage;
  VerifyOtpFailedState({required this.errorMessage});
}

final class ResetPassSuccessState extends AuthActionState {}
final class ResetPassFailedState extends AuthActionState {
  final String errorMessage;
  ResetPassFailedState({required this.errorMessage});
}


//? Log Out
final class LogoutSuccessState extends AuthActionState {}
final class LogoutFailedState extends AuthActionState {}