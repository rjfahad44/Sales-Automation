import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../Components/OrderUploadResponseCustomDialog.dart';
import '../../Components/TransparentProgressDialog.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../Models/OrderCreate.dart';
import '../../global.dart';
import '../Order/OrderCreateScreen.dart';
import '../Order/OrderHistoryScreen.dart';

class OrderDraftScreen extends StatefulWidget {
  const OrderDraftScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrderDraftScreenState();
}

class _OrderDraftScreenState extends State<OrderDraftScreen> {
  OrderAPI orderAPI = OrderAPI();
  List<OrderCreate> orderList = [];
  double totalAmount = 0.0;
  double totalDiscount = 0.0;
  double finalAmount = 0.0;
  bool isLoading = true;
  final orderSaveHiveBox = HiveBoxHelper<OrderCreate>('order_db');

  @override
  void initState() {
    getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: MyTextView("Order Draft", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orderList.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 4.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              var data = orderList[index];
                              totalAmount = data.totalAmount.toDouble();
                              finalAmount = data.finalAmount;
                              totalDiscount = data.totalDiscount;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                  semanticContainer: true,
                                  color: primaryButtonColor,
                                  elevation: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "chemist Name : ${data.chemist}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                              Text(
                                                "Delivery Date : ${data.deliveryDate}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                              Text(
                                                "Delivery Time : ${data.deliveryTime}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                              Text(
                                                "Total Products : ${data.products.length}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                              Text(
                                                "Price : ${totalAmount.toStringAsFixed(2)}৳",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                              Text(
                                                "Discount : ${totalDiscount.toStringAsFixed(2)}৳",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                              Container(
                                                height: 1,
                                                color: Colors.grey,
                                                width: double.infinity,
                                              ),
                                              Text(
                                                "Total Price : ${finalAmount.toStringAsFixed(2)}৳",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (String value) async {
                                          switch (value) {
                                            case 'Send':
                                              submitOrderFromArchive(data);
                                              break;
                                            case 'Edit':
                                              print("loop index : $index");
                                              position = await orderSaveHiveBox
                                                  .getPosition(data);
                                              print("box index : $position");
                                              print("data : $data");
                                              orderCreate = data;
                                              orderCreateCopy = data;
                                              goToPage(
                                                  const OrderCreateScreen(),
                                                  true,
                                                  context);
                                              break;
                                            case 'Delete':
                                              orderSaveHiveBox
                                                  .deleteItem(data)
                                                  .then((value) {
                                                getAllOrders();
                                              });
                                              break;
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                            value: 'Send',
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Icon(
                                                    Icons.send,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                                Text(
                                                  'Send',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Edit',
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                                Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Delete',
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                        color:
                                            primaryMenuColor, // Customize the icon as needed
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 16,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => primaryButtonColor),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          onPressed: () {
                            submitOrderListFromArchive(orderList);
                            // for (int i = 0; i < orderList.length; i++) {
                            //   submitOrderFromArchive(orderList[i], i);
                            // }
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
                    child: MyTextView("No CurrentUserData Found!", 18,
                        FontWeight.bold, Colors.black, TextAlign.center),
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

  Future<void> submitOrderFromArchive(OrderCreate data) async {
    showTransparentProgressDialog(context);
    orderAPI.submitOrderFromArchive(data, (isSuccess, response) {
      hideTransparentProgressDialog(context);
      if (isSuccess) {
        orderSaveHiveBox.deleteItem(data);
        getAllOrders();
        Fluttertoast.showToast(
            msg: "Order Successfully Submitted.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        goToPage(const OrderHistoryScreen(), true, context);
        // showBottomSheetDialog(context, response, response.message, totalAmount,
        //     totalDiscount, finalAmount, () {});
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

  Future<void> submitOrderListFromArchive(List<OrderCreate> orderList) async {
    showTransparentProgressDialog(context);
    orderAPI.submitOrderListFromArchive(orderList, orderSaveHiveBox,
        (isSuccess, totalOrders, totalPrice) {
      hideTransparentProgressDialog(context);
      getAllOrders();
      if (isSuccess) {
        // showBottomSheetDialog(context, null, "Orders Successfully Submitted.",
        //     totalPrice, totalOrders.toDouble(), totalPrice, () {});
        Fluttertoast.showToast(
            msg: "Orders Successfully Submitted.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        goToPage(const OrderHistoryScreen(), true, context);
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
}
