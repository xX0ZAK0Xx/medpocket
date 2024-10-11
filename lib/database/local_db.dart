import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {

  //!POST Login Information
  static Future<void> postLoginInfo({required String email, required String password, required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final box = await Hive.openBox(loginBox);
    // box.put(loginBox, [
    //   email,
    //   password,
    //   token
    // ]);
    await prefs.setString('email_musafir_agent', email);
    await prefs.setString('password_musafir_agent', password);
    await prefs.setString('token_musafir_agent', token);
  }

  //!Get Token 
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_musafir_agent')?? "";
  }

  //!Get Login Information
  static Future<List<String>?> getLoginInfo() async{
    // final box = await Hive.openBox(loginBox);
    // final info = box.get(loginBox);
    // return info;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [prefs.getString('email_musafir_agent')??"", prefs.getString('password_musafir_agent')??"", prefs.getString('token_musafir_agent')??""];
  }

  //!DEL Login Information
  static Future<void> delLoginInfo() async {
    // final box = await Hive.openBox(loginBox);
    // await box.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> setHajjUmrah({required bool isHajj})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('isHajjUmrah_musafir_agent', '$isHajj');
  }
  
  static Future<String?> getHajjUmrah() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('isHajjUmrah_musafir_agent')?? "";
  }
}