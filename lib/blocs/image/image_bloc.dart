import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../configs/app_constants.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {

  String originalImagePath = '';
  String resizedImagePath = '';
  bool onlineImage = false;

  final ImagePicker imagePicker = ImagePicker();

  ImageBloc() : super(ImageInitial()) {
    on<SelectImageEvent>(selectImage);
    on<ValidateImageEvent>(validateImageEvent);
  }

  FutureOr<void> selectImage(SelectImageEvent event, Emitter<ImageState> emit) async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: event.fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (image != null) {
        // Load and resize the image
        Uint8List imageBytes = await image.readAsBytes();
        ui.Codec originalCodec = await ui.instantiateImageCodec(imageBytes);
        ui.FrameInfo originalFrameInfo = await originalCodec.getNextFrame();
        ui.Image originalImage = originalFrameInfo.image;

        int originalWidth = originalImage.width;
        int originalHeight = originalImage.height;

        const int targetWidth = 500;
        double aspectRatio = originalWidth / originalHeight;
        int targetHeight = (targetWidth / aspectRatio).round();

        ui.Codec resizedCodec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: targetWidth,
          targetHeight: targetHeight,
        );
        ui.FrameInfo resizedFrameInfo = await resizedCodec.getNextFrame();
        ui.Image resizedImage = resizedFrameInfo.image;

        ByteData? byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List resizedImageBytes = byteData.buffer.asUint8List();
          Directory documentsDirectory = await getApplicationDocumentsDirectory();
          String targetPath = '${documentsDirectory.path}/${event.usedFor}_resized_image.png';
          File resizedImageFile = File(targetPath);
          await resizedImageFile.writeAsBytes(resizedImageBytes);

          originalImagePath = image.path;
          resizedImagePath = targetPath;
          onlineImage = false;
          emit(ImageSelectSuccessState());
        } else {
          emit(ImageSelectFailedState());
        }
      } else {
        if(resizedImagePath.isEmpty){
          emit(ImageNotSelectState());
        }
      }
    } catch (e) {
      logger.e("Error: $e");
      emit(ImageSelectFailedState());
    }
  }

  FutureOr<void> validateImageEvent(ValidateImageEvent event, Emitter<ImageState> emit) {
    if(resizedImagePath.isEmpty){
      emit(ImageNotSelectState());
    }
  }
}
