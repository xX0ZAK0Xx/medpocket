import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchCall({required String phoneNumber}) async {
  final Uri urlParsed = Uri.parse('tel:$phoneNumber');

  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed);
  } else {
    throw 'Could not launch call to: $phoneNumber';
  }
}

Future<void> launchUrlSite({required String url}) async {
  final Uri urlParsed = Uri.parse(url);

  if (await canLaunchUrl(urlParsed)) {
    await launchUrl(urlParsed);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchEmail({required String email}) async {
  final String email2 = Uri.encodeComponent(email);
  final Uri mail = Uri.parse("mailto:$email2");

  try {
    final bool launched = await launchUrl(mail);
    if (launched) {
      // email app opened
    } else {
      // email app is not opened
      throw Exception('Could not launch email app');
    }
  } on PlatformException catch (e) {
    throw Exception('Error launching email: $e');
  }
}