import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static SnackBar loadingSnackbar ({required String title, required String message}) =>  SnackBar(
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.warning,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    duration: Duration(milliseconds: 800),
  );
  static SnackBar failedSnackbar ({required String title, required String message}) =>  SnackBar(
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.failure,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
  );
  static SnackBar successSnackbar ({required String title, required String message}) =>  SnackBar(
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.success,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
  );
}