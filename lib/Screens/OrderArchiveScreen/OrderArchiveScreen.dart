import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../global.dart';
import '../Order/Models/OrderCreate.dart';

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
    getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              var data = orderList[index];

                              return Card(
                                elevation: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "chemist Name : ${data.chemist}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                            Text(
                                              "Delivery Date : ${data.deliveryDate}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                            Text(
                                              "Delivery Time : ${data.deliveryTime}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                            Text(
                                              "Total Products : ${data.products.length}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                            Text(
                                              "Total Amount : ${data.totalAmount}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            orderSaveHiveBox.delete(index);
                                            getAllOrders();
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.send,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            submitOrderFromArchive(data, index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 16,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.cyan),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          onPressed: () {
                            for(int i=0; i<orderList.length; i++){
                              submitOrderFromArchive(orderList[i], i);
                            }
                          },
                          child: MyTextView("Submit All", 12, FontWeight.bold,
                              Colors.white, TextAlign.center),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  )
                : Center(
                    child: MyTextView("No Data Found!", 18, FontWeight.bold,
                        Colors.black, TextAlign.center),
                  ),
      ),
    );
  }

  getAllOrders() async {
    orderSaveHiveBox.getAll().then((value) {
      setState(() {
        orderList = value;
        isLoading = false;
      });
      print("Saved Products : ${value.toString()}");
    });
  }

  Future<void> submitOrderFromArchive(OrderCreate data, int index) async {
    bool status = await orderAPI.submitOrderFromArchive(data);
    if (status) {
      orderSaveHiveBox.delete(index);
      getAllOrders();
      Fluttertoast.showToast(
          msg: "Submit successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
}
