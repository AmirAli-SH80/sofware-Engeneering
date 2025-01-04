import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modiryat_mali/screens/home_screen.dart';
import 'package:modiryat_mali/screens/main_screen.dart';
import 'models/money.dart';

void main()async{
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  await Hive.openBox<Money>('moneyBox');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static void getData(){
  HomeScreen.moneys.clear();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  for (var value in hiveBox.values) {
    HomeScreen.moneys.add(value);
    }
  }


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'برنامه مدیریت مالی',
      home:MainScreen()
    );
  }
}
