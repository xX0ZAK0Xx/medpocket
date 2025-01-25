part of 'image_bloc.dart';

sealed class ImageState{}

final class ImageInitial extends ImageState {}

final class ImageActionState extends ImageState {}
final class ImageLoadingState extends ImageActionState {}
final class ImageSelectSuccessState extends ImageActionState {}
final class ImageSelectFailedState extends ImageActionState {}
final class ImageNotSelectState extends ImageActionState {}

class ImageDeleteSuccessState extends ImageState {}

class ImageDeleteFailedState extends ImageState {}