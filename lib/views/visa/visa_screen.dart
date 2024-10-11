import 'package:flutter/material.dart';

class VisaScreen extends StatelessWidget {
  const VisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Details'),
      ),
      body: const Center(
        child: Text('Visa Screen'),
      ),
    );
  }
}
