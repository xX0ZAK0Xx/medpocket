import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:medpocket/configs/app_urls.dart';

import '../configs/app_constants.dart';

Future<String> postResponse({
  required String url,
  Map<String, dynamic>? payload,
  String? token,
}) async {
  Uri uriUrl = Uri.parse(url);

  final Map<String, String> header = {
    "Content-Type": "application/json",
    if (token != null) "Authorization": "Bearer $token",
  };

  try {
    final response = await http.post(uriUrl,body: payload == null ? null : jsonEncode(payload), headers: header).timeout(const Duration(seconds: 10));
    logger.i("postResponse body: ${response.body}");
    return response.body;
  } on TimeoutException {
    return '''
{
   "success": false,
   "title": "Timeout",
   "message": "The request timed out. Please try again later.",
   "data": null
}
''';
  } on SocketException {
    return '''
{
   "success": false,
   "title": "Connection Failed",
   "message": "Unable to connect to the server. Please check your network connection and try again.",
   "data": null
}
''';
  } catch (e) {
    return '''
{
   "success": false,
   "title": "Failed",
   "message": "An error occurred while communicating with the server",
   "data": null
}
''';
  }
}



Future<String> postImageResponse({
  required String url,
  required Map<String, String> payload,
  Map<String, String>? photoPath,
  required String token,
  String? from,
}) async {
  Uri uriUrl = Uri.parse(url);

  final Map<String, String> header = {}; // Removed Content-Type

  try {
    var request = http.MultipartRequest('POST', uriUrl);

    request.fields.addAll(payload);

    // Add files from the photoPath map
    if (photoPath != null && photoPath.isNotEmpty) {
      for (var entry in photoPath.entries) {
        logger.d("key: ${entry.key}, value: ${entry.value}");
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
      }
    }

    // Add headers and authorization if necessary
    request.headers.addAll(header);
    if (token.isNotEmpty) {
      request.headers["Authorization"] = "Bearer $token";
    }

    // Send the request
    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();

    log("respStr: $respStr"); // Updated logging
    return respStr;
  } on TimeoutException {
    return '''
{
   "success": false,
   "title": "Timeout",
   "message": "The request timed out. Please try again later.",
   "data": null
}
''';
  } on SocketException {
    return '''
{
   "success": false,
   "title": "Connection Failed",
   "message": "Unable to connect to the server. Please check your network connection and try again.",
   "data": null
}
''';
  } catch (e) {
    return '''
{
   "success": false,
   "title": "Failed",
   "message": "An error occurred while communicating with the server",
   "data": null
}
''';
  }
}