import 'package:logger/web.dart';

class AppConstants {
  static const String appName             = 'Med Pocket';
  static const String oneWay              = 'One Way';
  static const String roundWay            = 'Round Trip';
  static const String multiCity           = 'Multi City';
  static const String economy             = "Economy";
  static const String economyValue        = "Y";
  static const String premiumEconomy      = "Premium Economy";
  static const String premiumEconomyValue = "P";
  static const String businessClass       = "Business Class";
  static const String businessClassValue  = "J";
  static const String firstClass          = "First Class";
  static const String firstClassValue     = "F";

  static const List<String> gender = ["Male", "Female", "Other"];
  static const List<String> title = ["MR", "MS", "MRS", "MX"];

  static const String exceptionM = "We encountered an unexpected error. Please try again later.";
  static const String exceptionT = "Something Went Wrong";
  static const String socketM = "We were unable to connect to the server. Please try again later.";
  static const String socketT = "Connection Error";
  static const String timeoutT = "Timeout Error";
  static const String timeoutM = "The request timed out. Please try again later.";

  static const String resetUser = "reset_user";
  static const String verifyUser = "verify_user";
  static final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
}
Logger logger = Logger();
