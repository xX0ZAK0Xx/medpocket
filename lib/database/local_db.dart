import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/dashboard/dashboard_model.dart' show DashboardModel;
import '../models/measurements/measurements_model.dart' show MeasurementsModel;
import '../models/model.dart' show ProfileModel;

class LocalDB {

  //!POST Login Information
  static Future<void> postLoginInfo({required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email_med_pocket', email);
    await prefs.setString('password_med_pocket', password);
  }

  //!Get id 
  static Future<String?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_med_pocket')?? "";
  }
  //!Get id 
  static Future<void> setId({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id_med_pocket', id);
  }
  //!Get Token 
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_med_pocket')?? "";
  }

  //!Get Login Information
  static Future<List<String>?> getLoginInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [prefs.getString('email_med_pocket')??"", prefs.getString('password_med_pocket')??""];
  }

  //!DEL Login Information
  static Future<void> delLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  //! Get Profile Data
  static Future<ProfileModel?> getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('profileData_med_pocket');
    log("local data: $data");
    return ProfileModel.fromJson(jsonDecode(data??"{}"));
  }

  //! Set Profile Data
  static Future<void> setProfileData(ProfileModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("setting local data: $data");
    await prefs.setString('profileData_med_pocket', jsonEncode(data.toJson()));
  }

  //! Get Dashboard Data
  static Future<DashboardModel?> getDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('dashboardData_med_pocket');
    log("local data: $data");
    return DashboardModel.fromJson(jsonDecode(data??"{}"));
  }

  //! Set Dashboard Data
  static Future<void> setDashboardData(DashboardModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("setting local data: $data");
    await prefs.setString('dashboardData_med_pocket', jsonEncode(data.toJson()));
  }

  //! get MeasurementsModel
  static Future<MeasurementsModel?> getMeasurementsModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('measurementsData_med_pocket');
    log("local data: $data");
    return MeasurementsModel.fromJson(jsonDecode(data??"{}"));
  }

  //! set MeasurementsModel
  static Future<void> setMeasurementsModel(MeasurementsModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("setting local data: $data");
    await prefs.setString('measurementsData_med_pocket', jsonEncode(data.toJson()));
  }
}