import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_automation/APIs/OrderAPI.dart';
import 'package:sales_automation/Screens/HomeScreen.dart';

import '../../Components/Components.dart';
import '../../Models/Cart.dart';
import '../../global.dart';

class OrderSummeryScreen extends StatefulWidget {
  OrderSummeryScreen({super.key, required this.carts});
  List<Cart> carts;

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {

  double totalAmount = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceCalculate();
  }

  @override
  Widget build(BuildContext context) {




    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Summery", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body:  Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.carts!.length,
              itemBuilder: (context, index) {
                return Card(
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyTextView(
                            widget.carts[index].itemName,
                            14,
                            FontWeight.normal,
                            Colors.black,
                            TextAlign.center),
                        MyTextView(
                            widget.carts[index].quantity.toString(),
                            14,
                            FontWeight.normal,
                            Colors.black,
                            TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
            MyTextView("Total: ${(totalAmount==0)?"Calculating":totalAmount}", 16, FontWeight.bold, Colors.black,
                TextAlign.center),

            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
              onPressed: () {
                submitOrder();
              },
              child: MyTextView("Submit", 12, FontWeight.bold, Colors.white,
                  TextAlign.center),
            ),



          ],
        ),
      ),
    );
  }

  Future<void> priceCalculate() async {
    OrderAPI orderAPI = OrderAPI();


    for(int i =0; i<widget.carts.length; i++){
      widget.carts[i].unitPrice =  await orderAPI.getItemPrice(widget.carts[i].itemID);
      totalAmount = totalAmount + (widget.carts[i].unitPrice * widget.carts[i].quantity);
    }
    setState(() {

    });
  }

  Future<void> submitOrder() async {

    OrderAPI api = OrderAPI();

    bool status = await api.submitOrder(widget.carts);
    if(status){
      Fluttertoast.showToast(
          msg: "Submit successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }
}
