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
    fetchData();
    super.initState();
  }
  void fetchData(){
    context.read<MedicineBloc>().add(GetAllMedicineEvent(token: context.read<AuthBloc>().token??""));
    context.read<MedicineBloc>().add(GetTodaysMedicineEvent(token: context.read<AuthBloc>().token??""));
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
      body: BlocConsumer<MedicineBloc, MedicineState>(
        listener: (context, state) {
          if(state is UpdateMedicineLoadingState){
            // AppSnackbar.loadingSnackbar(title: "Please wait", message: "We are updating your medicine");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Please wait"),
              duration: Duration(seconds: 1),
            ));
          }else if(state is UpdateMedicineSuccessState){
            fetchData();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Medicine has been updated successfully"),
              duration: Duration(seconds: 1),
            ));
            // AppSnackbar.successSnackbar(title: "Success", message: "Medicine has been updated successfully");
          }else if(state is UpdateMedicineFailedState){
            // AppSnackbar.failedSnackbar(title: "Failed", message: state.errorMessage);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              duration: Duration(seconds: 1),
            ));
          }else if(state is MarkAsTakenMedicineFailedState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              duration: Duration(seconds: 2),
            ));
          }else if(state is DeleteMedicineSuccessState){
            fetchData();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Medicine was successfully deleted"),
              duration: Duration(seconds: 1),
            ));
          }else if(state is DeleteMedicineFailedState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              duration: Duration(seconds: 1),
            ));
          }
        },
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
