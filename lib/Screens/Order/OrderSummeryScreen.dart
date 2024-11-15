import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:sales_automation/APIs/OrderAPI.dart';
import 'package:sales_automation/Screens/HomeScreen/HomeScreen.dart';
import '../../Components/Components.dart';
import '../../Components/OrderUploadResponseCustomDialog.dart';
import '../../Components/TransparentProgressDialog.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../Models/Cart.dart';
import '../../Models/OrderCreate.dart';
import '../../global.dart';

class OrderSummeryScreen extends StatefulWidget {
  final List<Cart> carts;

  const OrderSummeryScreen({super.key, required this.carts});

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  final orderSaveHiveBox = HiveBoxHelper<OrderCreate>('order_db');
  OrderAPI orderAPI = OrderAPI();
  double totalAmount = 0.0;
  double totalDiscount = 0.0;
  double finalAmount = 0.0;

  @override
  void initState() {
    priceCalculate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: primaryButtonColor,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyTextView(widget.carts[index].itemName, 12, FontWeight.normal, Colors.white, TextAlign.center),
                          MyTextView("Quantity: ${widget.carts[index].quantity}", 12, FontWeight.normal, Colors.white, TextAlign.center),
                          MyTextView("Price: ${widget.carts[index].unitPrice}৳", 12, FontWeight.normal, Colors.white, TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextView(
                      "Price: ${totalAmount.toStringAsFixed(2)}৳",
                      16,
                      FontWeight.bold,
                      Colors.black,
                      TextAlign.start),

                  MyTextView(
                      "Discount: ${totalDiscount.toStringAsFixed(2)}৳",
                      16,
                      FontWeight.bold,
                      Colors.black,
                      TextAlign.start),

                  Container(
                    height: 1,
                    color: Colors.grey,
                    width: double.infinity,
                  ),

                  MyTextView(
                      "Total Price: ${finalAmount.toStringAsFixed(2)}৳",
                      16,
                      FontWeight.bold,
                      Colors.black,
                      TextAlign.start),
                ],
              ),
            ),

            Row(
              children: [
                const SizedBox(width: 8.0,),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        WidgetStateColor.resolveWith((states) => primaryButtonColor),
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
                        WidgetStateColor.resolveWith((states) => primaryButtonColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                    onPressed: () {
                      saveOrder();
                    },
                    child: MyTextView(position == -1 ? "Save" : "Update", 12, FontWeight.bold, Colors.white,
                        TextAlign.center),
                  ),
                ),
                const SizedBox(width: 8.0,),
              ],
            ),

            const SizedBox(height: 8.0,),
          ],
        ),
      );
  }

  Future<void> priceCalculate() async {
    double newTotalAmount = 0.0;
    double newDiscount = 0.0;
    double newFinalAmount = 0.0;
    for (var item in widget.carts) {
      newTotalAmount += item.quantity * item.unitPrice;
      //newDiscount += item.calculateDiscount(item.unitPrice, item.quantity, item.discountValue, item.discountType, item.minimumQuantity);
      newFinalAmount += item.calculateFinalPrice(item.unitPrice, item.quantity, item.discountValue, item.discountType, item.minimumQuantity);
    }
    setState(() {
      totalAmount = newTotalAmount;
      totalDiscount =  newTotalAmount == newFinalAmount? 0.0: (newTotalAmount - newFinalAmount);
      finalAmount = newFinalAmount;
    });
  }

  Future<void> submitOrder() async {
    showTransparentProgressDialog(context);
    orderAPI.submitOrder(widget.carts, (isSuccess, response) {
      hideTransparentProgressDialog(context);
      if (isSuccess) {
        showBottomSheetDialog(
            context, response, response.message, totalAmount, totalDiscount, finalAmount, () {
          goToPage(const HomeScreen(), false, context);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<void> saveOrder() async {
    print("OrderCreate : ${orderCreate.toString()}");
    if(position != -1){
      orderSaveHiveBox.update(position, orderCreate).then((value) {
        orderCreate = OrderCreate();
        orderCreateCopy = OrderCreate();
        print("Product Update position : $position");
        Fluttertoast.showToast(
            msg: "update successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        goToPage(const HomeScreen(), false, context);
      });
    }else{
      orderSaveHiveBox.add(orderCreate).then((value) {
        orderCreate = OrderCreate();
        orderCreateCopy = OrderCreate();
        print("Product Save : ${value}");
        print("orderCreate : ${orderCreate}");
        Fluttertoast.showToast(
            msg: "Save successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        goToPage(const HomeScreen(), false, context);
      });
    }
  }
}
