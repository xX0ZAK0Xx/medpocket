import 'package:flutter/material.dart';

class BookedFlightScreen extends StatelessWidget {
  const BookedFlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Flight Details'),
      ),
      body: const Center(
        child: Text('My Booked Flight Details Screen'),
      ),
    );
  }
}
