import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_automation/Screens/Order/OrderCreateScreen.dart';

import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../Models/OrderCreate.dart';
import '../../global.dart';

class OrderArchiveScreen extends StatefulWidget {
  const OrderArchiveScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrderArchiveScreenState();
}

class _OrderArchiveScreenState extends State<OrderArchiveScreen> {
  OrderAPI orderAPI = OrderAPI();
  List<OrderCreate> orderList = [];
  double totalAmount = 0.0;
  bool isLoading = true;
  final orderSaveHiveBox = HiveBoxHelper<OrderCreate>('order_db');

  @override
  void initState() {
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: MyTextView("Order Archive", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orderList.isNotEmpty
                ? Column(
                    children: [

                    ],
                  )
                : Center(
                    child: MyTextView("No CurrentUserData Found!", 18, FontWeight.bold,
                        Colors.black, TextAlign.center),
                  ),
      );
  }
}
