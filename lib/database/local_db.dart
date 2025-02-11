import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {

  //!POST Login Information
  static Future<void> postLoginInfo({required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final box = await Hive.openBox(loginBox);
    // box.put(loginBox, [
    //   email,
    //   password,
    //   token
    // ]);
    await prefs.setString('email_med_pocket', email);
    await prefs.setString('password_med_pocket', password);
  }

  //!Get id 
  static Future<String?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_med_pocket')?? "";
    // return "671bca7f3c243fa0e37e9427";
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
    // final box = await Hive.openBox(loginBox);
    // final info = box.get(loginBox);
    // return info;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [prefs.getString('email_med_pocket')??"", prefs.getString('password_med_pocket')??""];
  }

  //!DEL Login Information
  static Future<void> delLoginInfo() async {
    // final box = await Hive.openBox(loginBox);
    // await box.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}