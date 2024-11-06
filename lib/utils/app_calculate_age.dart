int calculateAge(DateTime birthDate) {
  // Get the current date
  DateTime currentDate = DateTime.now();
  
  // Calculate the difference in years
  int age = currentDate.year - birthDate.year;
  
  // Adjust if the birthday hasn't occurred yet this year
  if (currentDate.month < birthDate.month || 
     (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
    age--;
  }
  
  return age;
}