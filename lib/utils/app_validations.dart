bool emailValidate(String value) {
  const emailPattern = r'^[^@]+@[^@]+\.[^@]+';
  final regex = RegExp(emailPattern);

  return regex.hasMatch(value);
}


bool passwordValidate(String value) {
  final hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
  final hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
  final hasDigit = RegExp(r'[0-9]').hasMatch(value);
  final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  return hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar;
}


bool isValidPhoneNumber(String phoneNumber) {
  final regex = RegExp(r'^(?:\+?88)?01[3-9]\d{8}$');
  return regex.hasMatch(phoneNumber);
}

bool isValidFullName(String fullName) {
  final regex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
  return regex.hasMatch(fullName);
}

bool isValidPassportNumber(String passportNumber) {
  // Regular expression to check if the passport number consists of 6 to 9 alphanumeric characters
  final RegExp passportRegex = RegExp(r'^[A-Z0-9]{6,9}$');

  // Check if the passport number matches the regular expression
  return passportRegex.hasMatch(passportNumber);
}
