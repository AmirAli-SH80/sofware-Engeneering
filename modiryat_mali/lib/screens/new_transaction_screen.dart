import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modiryat_mali/main.dart';
import 'package:modiryat_mali/models/money.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:modiryat_mali/utils/extension.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});
  static int groupeId = 0;
  static TextEditingController describtionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;
  static String Date = 'تاریخ';

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NewTransactionScreen.isEditing ?'ویرایش تراکنش ':'تراکنش جدید',
                style: TextStyle(fontSize:screenSize(context).screenWith < 1100? 14 :  screenSize(context).screenWith * 0.015,),
              ),
              MyTextField(
                hintText: 'توضیحات',
                controller: NewTransactionScreen.describtionController,
              ),
              MyTextField(
                hintText: 'مبلغ',
                Type: TextInputType.number,
                controller: NewTransactionScreen.priceController,
              ),
              const TypeAndDateWidget(),
              MyButtom(
                text: NewTransactionScreen.isEditing ?'ویرایش کردن ':' اضافه کردن',
                onPressed: () {
                  Money item =
                    Money(
                        id: Random().nextInt(999999),
                        title: NewTransactionScreen.describtionController.text,
                        price: NewTransactionScreen.priceController.text,
                        date: NewTransactionScreen.Date,
                        isRecived:
                        NewTransactionScreen.groupeId == 1 ? true : false);
                  
                  if (NewTransactionScreen.isEditing) {
                    int index =0;
                    MainApp.getData();
                    for (var i = 0; i < hiveBox.values.length; i++) {
                      if (hiveBox.values.elementAt(i).id == NewTransactionScreen.id) {
                        index = i;
                      }
                      
                    }
                    // HomeScreen.moneys[NewTransactionScreen.index]=item;
                    hiveBox.putAt(index, item);
                  }
                  else{
                    // HomeScreen.moneys.add(item);
                    hiveBox.add(item);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//MyButtom
class MyButtom extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const MyButtom({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 77, 255, 104)),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

//TypeAndDateWidget
class TypeAndDateWidget extends StatefulWidget {
  const TypeAndDateWidget({
    super.key,
  });

  @override
  State<TypeAndDateWidget> createState() => _TypeAndDateWidgetState();
}

class _TypeAndDateWidgetState extends State<TypeAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MyRadioButtom(
            value: 1,
            groupValue: NewTransactionScreen.groupeId,
            onChanged: (value) {
              setState(() {
                NewTransactionScreen.groupeId = value!;
              });
            },
            text: 'دریافتی',
          ),
        ),
        Expanded(
          child: MyRadioButtom(
            value: 2,
            groupValue: NewTransactionScreen.groupeId,
            onChanged: (value) {
              setState(() {
                NewTransactionScreen.groupeId = value!;
              });
            },
            text: 'پرداختی',
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: OutlinedButton(
            onPressed: () async{
              var pickDate = await showPersianDatePicker(context: context, initialDate: Jalali.now(), firstDate: Jalali(1400), lastDate: Jalali(1700));
              setState(() {
                String year = pickDate!.year.toString();
                String month = pickDate.month.toString().length == 1? '0${pickDate.month.toString()}': pickDate.month.toString();
                String day = pickDate.day.toString().length == 1? '0${pickDate.day.toString()}': pickDate.day.toString();;
          
          
                NewTransactionScreen.Date = year + '/' + month + '/' + day;
              });
            },
            child: Text(
              NewTransactionScreen.Date,
              style: const TextStyle(color: Colors.blue,fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

//MyRadioButtom
class MyRadioButtom extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;

  const MyRadioButtom(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Radio(value: value, groupValue: groupValue, onChanged: onChanged)),
        Text(text),
      ],
    );
  }
}

//MyTextField
class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType Type;
  final TextEditingController controller;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.Type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: Type,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      cursorColor: Colors.blue,
    );
  }
}
