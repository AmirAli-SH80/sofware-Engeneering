import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modiryat_mali/constant.dart';
import 'package:modiryat_mali/main.dart';
import 'package:modiryat_mali/models/money.dart';
import 'package:modiryat_mali/screens/new_transaction_screen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modiryat_mali/utils/extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static List<Money> moneys = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  static  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  void initState() {
    MainApp.getData();
    super.initState();
  }

  bool isSearchBarOpen = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabwidget(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildSearchBar(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'تراکنش‌ها',
                    style: TextStyle(
                      fontSize: screenSize(context).screenWith < 1100
                          ? 16
                          : screenSize(context).screenWith * 0.01,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "لیست تراکنش‌ها",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: HomeScreen.moneys.isEmpty
                    ? const EmtyWidget()
                    : ListView.builder(
                        itemCount: HomeScreen.moneys.length,
                        itemBuilder: (context, index) {
                          return MyListTittleWidget(index: index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fabwidget() {
    return FloatingActionButton(
      onPressed: () {
        NewTransactionScreen.Date = 'تاریخ';
        NewTransactionScreen.describtionController.text = '';
        NewTransactionScreen.priceController.text = '';
        NewTransactionScreen.groupeId = 0;
        NewTransactionScreen.isEditing = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewTransactionScreen(),
          ),
        ).then((value) {
          MainApp.getData();
          setState(() {});
        });
      },
      child: const Icon(Icons.add),
    );
  }

//search widget
  Widget buildSearchBar() {
    return SearchBarAnimation(
      textEditingController: searchController,
      isOriginalAnimation: false,
      searchBoxWidth: MediaQuery.of(context).size.width * 0.8,
      hintText: 'جستجو...',
      buttonBorderColour: Colors.black45,
      onExpansionComplete: () {
        setState(() {});
      },
      onCollapseComplete: () {
        MainApp.getData();
        searchController.text = '';
        setState(() {});
      },
      onFieldSubmitted: (String text) {
        List<Money> result = hiveBox.values
            .where((value) =>
                value.title.contains(text) || value.date.contains(text))
            .toList();

        HomeScreen.moneys.clear();
        setState(() {
          HomeScreen.moneys.addAll(result);
        });

        if (text.isEmpty) {
          print('Search cleared.');
        }
      },
      buttonWidget: const Icon(Icons.search, color: Colors.black),
      trailingWidget: IconButton(
        icon: const Icon(Icons.clear, color: Colors.red),
        onPressed: () {
          searchController.clear();
          print('Search cleared');
        },
      ),
      secondaryButtonWidget: Icon(Icons.arrow_back),
    );
  }


}

class MyListTittleWidget extends StatefulWidget {
  final int index;

  const MyListTittleWidget({super.key, required this.index});

  @override
  State<MyListTittleWidget> createState() => _MyListTittleWidgetState();
}

class _MyListTittleWidgetState extends State<MyListTittleWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.index >= HomeScreen.moneys.length) {
      return const SizedBox(); // جلوگیری از دسترسی غیرمجاز
    }

    return GestureDetector(
      //Edit
      onTap: () {
        if (widget.index < HomeScreen.moneys.length) {
          NewTransactionScreen.Date = HomeScreen.moneys[widget.index].date;
          NewTransactionScreen.describtionController.text =
              HomeScreen.moneys[widget.index].title;
          NewTransactionScreen.priceController.text =
              HomeScreen.moneys[widget.index].price;
          NewTransactionScreen.isEditing = true;
          NewTransactionScreen.id = HomeScreen.moneys[widget.index].id;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTransactionScreen(),
            ),
          ).then((value) {
            MainApp.getData();
          });
        }
      },
      onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'آیا از حذف این آیتم مطمئن هستید؟',
                style: TextStyle(fontSize: 12),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(onPressed: () {Navigator.pop(context);}, child: const Text('خیر')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        
                          Hive.box<Money>('moneyBox').deleteAt(widget.index);
                          HomeScreen.moneys.removeAt(widget.index);
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('بله'))
              ],
            ),
          );
        
      },
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: HomeScreen.moneys[widget.index].isRecived
                      ? kGreenColor
                      : kRedColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Icon(
                  HomeScreen.moneys[widget.index].isRecived
                      ? Icons.add
                      : Icons.remove,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                HomeScreen.moneys[widget.index].title,
                style: TextStyle(
                  fontSize: screenSize(context).screenWith < 1100
                      ? 14
                      : screenSize(context).screenWith * 0.015,
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'تومان',
                      style: TextStyle(
                          fontSize: screenSize(context).screenWith < 1100
                              ? 14
                              : screenSize(context).screenWith * 0.015,
                          color: kRedColor),
                    ),
                    Text(
                      HomeScreen.moneys[widget.index].price,
                      style: TextStyle(
                          fontSize: screenSize(context).screenWith < 1100
                              ? 14
                              : screenSize(context).screenWith * 0.015,
                          color: kRedColor),
                    ),
                  ],
                ),
                Text(HomeScreen.moneys[widget.index].date,
                    style: TextStyle(
                      fontSize: screenSize(context).screenWith < 1100
                          ? 12
                          : screenSize(context).screenWith * 0.015,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EmtyWidget extends StatelessWidget {
  const EmtyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          'assets/images/Bank.svg',
        ),
        const SizedBox(
          height: 13,
        ),
        const Text('تراکنشی وجود ندارد'),
        const Spacer(),
      ],
    );
  }
}
