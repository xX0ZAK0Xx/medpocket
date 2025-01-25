import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../configs/app_constants.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImagePicker _imagePicker = ImagePicker();
  final int _targetWidth = 500;

  String originalImagePath = '';
  String resizedImagePath = '';
  List<String> resizedMultiImagesPath = [];
  bool onlineImage = false;
  int index = 0;

  ImageBloc() : super(ImageInitial()) {
    on<SelectImageEvent>(_onSelectImage);
    on<ValidateImageEvent>(_onValidateImage);
    on<SelectMultipleImagesEvent>(_onSelectMultipleImages);
    on<DeleteImageEvent>(_onDeleteImage);
  }

  FutureOr<void> _onSelectImage(SelectImageEvent event, Emitter<ImageState> emit) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: event.fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        final String targetPath = await _processAndStoreImage(imageBytes, event.usedFor);

        // Update paths and state
        originalImagePath = image.path;
        resizedImagePath = targetPath;
        onlineImage = false;

        emit(ImageSelectSuccessState());
      } else if (resizedImagePath.isEmpty) {
        emit(ImageNotSelectState());
      }
    } catch (e) {
      logger.e("Error: $e");
      emit(ImageSelectFailedState());
    }
  }

  FutureOr<void> _onSelectMultipleImages(SelectMultipleImagesEvent event, Emitter<ImageState> emit) async {
    try {
      final List<XFile> images = event.fromCamera
          ? [await _imagePicker.pickImage(source: ImageSource.camera) as XFile]
          : await _imagePicker.pickMultiImage();

      for (final image in images) {
        final Uint8List imageBytes = await image.readAsBytes();
        await _processAndStoreImage(imageBytes, event.usedFor, isMultiple: true);
      }
      emit(ImageSelectSuccessState());
        } catch (e) {
      logger.e("Error: $e");
      emit(ImageSelectFailedState());
    }
  }

  FutureOr<void> _onDeleteImage(DeleteImageEvent event, Emitter<ImageState> emit) {
    try {
      resizedMultiImagesPath.removeAt(event.index);
      emit(ImageDeleteSuccessState());
    } catch (e) {
      logger.e("Error: $e");
      emit(ImageDeleteFailedState());
    }
  }

  FutureOr<void> _onValidateImage(ValidateImageEvent event, Emitter<ImageState> emit) {
    if (resizedImagePath.isEmpty || originalImagePath.isEmpty) {
      emit(ImageNotSelectState());
    }
  }

  /// Processes and stores an image, resizing it and saving it to a file.
  Future<String> _processAndStoreImage(Uint8List imageBytes, String usedFor, {bool isMultiple = false}) async {
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final int originalWidth = image.width;
    final int originalHeight = image.height;
    final double aspectRatio = originalWidth / originalHeight;
    final int targetHeight = (_targetWidth / aspectRatio).round();

    final ui.Codec resizedCodec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: _targetWidth,
      targetHeight: targetHeight,
    );
    final ui.FrameInfo resizedFrameInfo = await resizedCodec.getNextFrame();
    final ui.Image resizedImage = resizedFrameInfo.image;

    final ByteData? byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final Uint8List resizedImageBytes = byteData.buffer.asUint8List();
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final String targetPath = '${documentsDirectory.path}/${usedFor}_resized_image${index++}.png';
      final File resizedImageFile = File(targetPath);
      await resizedImageFile.writeAsBytes(resizedImageBytes);

      if (isMultiple) resizedMultiImagesPath.add(targetPath);
      return targetPath;
    }
    throw Exception("Failed to process image");
  }
}
