import 'package:flutter/material.dart';

import '../../configs/app_routes.dart';
import 'add_medicine_screen.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRoutes.push(context, AddMedicineScreen());
        },
        child: Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Medicine Screen'),
      ),
    );
  }
}
