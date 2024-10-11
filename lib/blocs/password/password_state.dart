part of 'password_bloc.dart';

sealed class PasswordState {}

final class PasswordInitial extends PasswordState {}

final class TogglePasswordState extends PasswordState {}