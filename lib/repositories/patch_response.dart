import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../configs/app_constants.dart';

Future<String> patchImageResponse({required String url, required Map<String, String> payload, required String? photoPath, required String token}) async {
  Uri uriUrl = Uri.parse(url);

  final Map<String, String> header = {'Authorization': 'Bearer $token'};

  try {
    var request = http.MultipartRequest('PATCH', uriUrl);

    request.fields.addAll(payload);

    if (photoPath != null && photoPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('avatar', photoPath));
    }

    request.headers.addAll(header);

    http.StreamedResponse response = await request.send();

    final respStr = await response.stream.bytesToString();

    logger.i("patchImageResponse respStr: $respStr");
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

//for without image

Future<String> patchResponse(
    {required String url, Map<String, dynamic>? payload, String? token}) async {
  Uri uriUrl = Uri.parse(url);

  final Map<String, String> header = {
    "Content-Type": "application/json",
    if (token != null) "Authorization": "Bearer $token"
  };

  try {
    final response = await http
        .patch(uriUrl,
            body: payload == null ? null : jsonEncode(payload), headers: header)
        .timeout(const Duration(seconds: 15));
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
