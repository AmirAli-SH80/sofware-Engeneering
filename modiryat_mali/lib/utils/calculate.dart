import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modiryat_mali/models/money.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';


Box<Money> hiveBox = Hive.box<Money>('moneyBox');



String year = Jalali.now().year.toString();
String month = Jalali.now().month.toString().length == 1? '0${Jalali.now().month}' : Jalali.now().month.toString();
String day = Jalali.now().day.toString().length == 1? '0${Jalali.now().day}' : Jalali.now().day.toString();



class Calculate {

  static String today (){

  return year + '/' + month + '/' + day;
  }




  static double pToday(){

    double result =0;

    for (var value in hiveBox.values) {
      if(value.date==today()&& value.isRecived== false){
        result+=double.parse(value.price);
      }
    }


    return result;
}


  static double dToday(){

    double result =0;

    for (var value in hiveBox.values) {
      if(value.date==today()&& value.isRecived== true){
        result+=double.parse(value.price);
      }
    }
    return result;
  }



  static double pMonth(){

    double result =0;

    for (var value in hiveBox.values) {
      if(value.date.substring(5 , 7)==month&& value.isRecived== false){
        result+=double.parse(value.price);
      }
    }
    return result;
  }



  static double dMonth(){

    double result =0;

    for (var value in hiveBox.values) {
      if(value.date.substring(5 , 7)==month&& value.isRecived== true){
        result+=double.parse(value.price);
      }
    }
    return result;
  }



  static double pYear(){

    double result =0;

    for (var value in hiveBox.values) {
      if(value.date.substring(0 , 4)==year&& value.isRecived== false){
        result+=double.parse(value.price);
      }
    }
    return result;
  }




  static double dYear(){

    double result =0;

    for (var value in hiveBox.values) {
      if(value.date.substring(0 , 4)==year&& value.isRecived== true){
        result+=double.parse(value.price);
      }
    }
    return result;
  }



}