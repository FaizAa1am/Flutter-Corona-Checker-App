import 'package:intl/intl.dart';
String dateFormatted()
{
  var now=DateTime.now();
  var Formater=new DateFormat("EEE , dd/MMM/yyyy");
  String formatted=Formater.format(now);
  return formatted;
}