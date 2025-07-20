part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthStateInitial extends AuthState {}
final class AuthActionState extends AuthState {}
//?Database Login
final class PreviousLoginInitial extends AuthState {}
final class NoPreviousDataState extends AuthState {}
final class PreviousAuthErrorState extends AuthActionState {
  final String errorMessage;

  PreviousAuthErrorState({required this.errorMessage });
}


//?Authentication
final class AuthLoadingState extends AuthActionState {}
final class AuthSuccessState extends AuthActionState {
  final bool allDone;

  AuthSuccessState({required this.allDone});
}
final class AuthErrorState extends AuthActionState {
  final String errorMessage;

  AuthErrorState({required this.errorMessage });
}

//?Verfication and user information
// final class NeedToVerifyState extends AuthActionState{}
// final class NeedToFillupInfoState extends AuthActionState{}

//? Password reset states
class PasswordResetSuccessState extends AuthState {}

class PasswordResetErrorState extends AuthState {
  final String errorMessage;

  PasswordResetErrorState({required this.errorMessage});
}

//? Log Out
final class LogoutSuccessState extends AuthActionState {}
final class LogoutFailedState extends AuthActionState {}


// firebase states
final class FirebaseAuthLoadingState extends AuthState {}

final class FirebaseAuthSuccessState extends AuthState {
  final User user;
  
  FirebaseAuthSuccessState({required this.user});
}

final class FirebaseAuthFailedState extends AuthState {
  final String message;

  FirebaseAuthFailedState({required this.message});
}

class UserAuthenticatedState extends AuthState {
  final User user;
  
  UserAuthenticatedState({required this.user});
}

class UserNotAuthenticatedState extends AuthState {}