
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../global.dart';
import '../Order/Models/OrderCreate.dart';


class OrderDraftScreen extends StatefulWidget{
  const OrderDraftScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrderDraftScreenState();
}

class _OrderDraftScreenState extends State<OrderDraftScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Order Draft", 16, FontWeight.bold, Colors.black, TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: Container(),
      ),
    );
  }
}