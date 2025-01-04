import 'package:flutter/material.dart';
import 'package:modiryat_mali/utils/calculate.dart';
import 'package:modiryat_mali/utils/extension.dart';
import 'package:modiryat_mali/widget/chart_widget.dart';


class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15, top: 15, left: 5),
                child: Text('مدیریت تراکنش‌ها به تومان',style: TextStyle(fontSize:screenSize(context).screenWith < 1100? 14 :  screenSize(context).screenWith * 0.01,)),
              ),
              money_info_widget(
                firstText: ': دریافتی امروز ',
                firstPrice: Calculate.dToday().toString(),
                secondText: ': پرداختی امروز ',
                secondPrice: Calculate.pToday().toString(),
              ),
              money_info_widget(
                firstText: ': دریافتی این ماه',
                firstPrice: Calculate.dMonth().toString(),
                secondText: ': پرداختی این ماه',
                secondPrice: Calculate.pMonth().toString(),
              ),
              money_info_widget(
                firstText: ': دریافتی امسال ',
                firstPrice: Calculate.dYear().toString(),
                secondText: ': پرداختی امسال ',
                secondPrice: Calculate.pYear().toString(),
              ),
              Spacer(),
              Calculate.dYear == 0 && Calculate.pYear == 0 ? Container() : Container(
                padding: const EdgeInsets.all(20.0),
                height: 200,
                child: const BarChartWidget()),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}


//money_info_widget
class money_info_widget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;
  const money_info_widget({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.firstPrice,
    required this.secondPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 20, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Text(
            secondPrice,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize:screenSize(context).screenWith < 1100 ? 14 :  screenSize(context).screenWith * 0.01,))),
          Expanded(child: Text(secondText,style: TextStyle(fontSize:screenSize(context).screenWith < 1100 ? 14 :  screenSize(context).screenWith * 0.01,))),
          Expanded(
              child: Text(
            firstPrice,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize:screenSize(context).screenWith < 1100? 14 :  screenSize(context).screenWith * 0.01,))),
          Expanded(child: Text(firstText,style: TextStyle(fontSize:screenSize(context).screenWith < 1100 ? 14 :  screenSize(context).screenWith * 0.01,)))
        ],
      ),
    );
  }
}
