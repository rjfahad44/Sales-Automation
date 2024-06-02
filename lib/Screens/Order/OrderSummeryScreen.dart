import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:sales_automation/APIs/OrderAPI.dart';
import 'package:sales_automation/Screens/HomeScreen/HomeScreen.dart';
import 'package:sales_automation/Screens/Order/Models/OrderCreate.dart';
import '../../Components/Components.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../Models/Cart.dart';
import '../../global.dart';

class OrderSummeryScreen extends StatefulWidget {
  final List<Cart> carts;

  const OrderSummeryScreen({super.key, required this.carts});

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  OrderAPI orderAPI = OrderAPI();
  double totalAmount = 0;
  final orderSaveHiveBox = HiveBoxHelper<OrderCreate>('order_db');

  @override
  void initState() {
    priceCalculate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView(
              "Summery", 16, FontWeight.bold, Colors.black, TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.carts.length,
                itemBuilder: (context, index) {
                  return Card(
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyTextView(widget.carts[index].itemName, 14,
                              FontWeight.normal, Colors.black, TextAlign.center),
                          MyTextView(widget.carts[index].quantity.toString(), 14,
                              FontWeight.normal, Colors.black, TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            MyTextView(
                "Total: ${(totalAmount == 0) ? "Calculating" : totalAmount}",
                16,
                FontWeight.bold,
                Colors.black,
                TextAlign.center),

            Row(
              children: [
                const SizedBox(width: 8.0,),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        WidgetStateColor.resolveWith((states) => Colors.cyan),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                    onPressed: () {
                      submitOrder();
                    },
                    child: MyTextView("Submit", 12, FontWeight.bold, Colors.white,
                        TextAlign.center),
                  ),
                ),

                const SizedBox(width: 8.0,),

                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        WidgetStateColor.resolveWith((states) => Colors.cyan),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                    onPressed: () {
                      saveOrder();
                    },
                    child: MyTextView("Save", 12, FontWeight.bold, Colors.white,
                        TextAlign.center),
                  ),
                ),
                const SizedBox(width: 8.0,),
              ],
            ),

            const SizedBox(height: 8.0,),
          ],
        ),
      ),
    );
  }

  Future<void> priceCalculate() async {
    double newTotalAmount = 0.0;
    for (var item in widget.carts) {
      newTotalAmount += item.unitPrice * item.quantity;
    }
    setState(() {
      totalAmount = newTotalAmount;
    });
  }

  Future<void> submitOrder() async {
    bool status = await orderAPI.submitOrder(widget.carts);
    if (status) {
      Fluttertoast.showToast(
          msg: "Submit successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> saveOrder() async {
    orderSaveHiveBox.add(orderCreate).then((value) {
      orderCreate = OrderCreate();
      print("Product Save : ${value}");
      Fluttertoast.showToast(
          msg: "Save successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
}
