class AppUrls {
  // static const String baseUrl = "http://192.168.0.158:9988/api/v1"; //!Local url
  static const String baseUrl = "https://medpocket-backend.vercel.app"; //!Live url

  static const String imageBaseUrl = 'https://m360-trabill.s3.ap-south-1.amazonaws.com/booking-expert-storage';

  static const String agencyToken = 'asdfasdmjbhfoiauhfeiuhewfa23a';
  static const String b2bToken = 'fe590330-62cc-4e28-87a6-01b0e8a6aa11';

  //! Auth 
  static const String signup = '$baseUrl/api/auth/signup';
  static const String login = '$baseUrl/api/auth/login';
  static const String requestReset = "$baseUrl/api/auth/request-password-reset";
  static const String verifyOtp = "$baseUrl/public/otp/match";
  static const String resetPassword = "$baseUrl/btob/auth/reset-password";

}
