part of 'image_bloc.dart';

sealed class ImageEvent {}

class SelectImageEvent extends ImageEvent {
  final bool fromCamera;
  final String usedFor;

  SelectImageEvent({required this.fromCamera, required this.usedFor});
}

class ValidateImageEvent extends ImageEvent {}

class SelectMultipleImagesEvent extends ImageEvent {
  final bool fromCamera;
  final String usedFor;

  SelectMultipleImagesEvent({required this.fromCamera, required this.usedFor});
}

class DeleteImageEvent extends ImageEvent {
  final int index;

  DeleteImageEvent(this.index);
}