part of 'image_bloc.dart';

sealed class ImageEvent {}

class SelectImageEvent extends ImageEvent {
  final bool fromCamera;
  final String usedFor;

  SelectImageEvent({required this.fromCamera, required this.usedFor});
}

class ValidateImageEvent extends ImageEvent {}