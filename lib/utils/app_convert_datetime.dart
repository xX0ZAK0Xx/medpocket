import 'package:intl/intl.dart';

convertDateTime(DateTime? dateTime, String format) {
  /* 
  format[
    'yyyy-MM-dd'
    'EEEE, MMM d, yyyy'
    'MM-dd-yyyy HH:mm'
    'MMM d, h:mm a'
    'E, d MMM yyyy HH:mm:ss'
  ]
  */
  if(dateTime == null){
    return '';
  }
  final dateFormatter = DateFormat(format);
  return dateFormatter.format(dateTime);
}