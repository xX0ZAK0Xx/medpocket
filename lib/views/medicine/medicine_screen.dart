import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medpocket/widgets/app_nothing_to_display.dart';

import '../../blocs/bloc.dart';
import '../../configs/app_routes.dart';
import 'segments/add_medicine_screen.dart';
import 'segments/todays_medicine.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  @override
  void initState() {
    context.read<MedicineBloc>().add(GetAllMedicineEvent(token: context.read<AuthBloc>().token??""));
    context.read<MedicineBloc>().add(GetTodaysMedicineEvent(token: context.read<AuthBloc>().token??""));
    super.initState();
  }
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
      body: BlocBuilder<MedicineBloc, MedicineState>(
        buildWhen: (previous, current) => current is GetTodaysMedicineFailedState || current is GetTodaysMedicineLoadingState || current is GetTodaysMedicineSuccessState,
        builder: (context, state) {
          if(state is GetTodaysMedicineLoadingState){
            return Center(child: CircularProgressIndicator.adaptive(),);
          }else if(state is GetTodaysMedicineSuccessState){
            return TodaysMedicineList(todaysMedicineData: state.todaysMedicine,);

          }else if(state is GetTodaysMedicineFailedState){
            return AppNothingToDisplay(message: state.errorMessage,);

          }else {
            return AppNothingToDisplay();
          }
        },
      ),
    );
  }
}
