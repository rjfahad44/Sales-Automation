import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:sales_automation/APIs/OrderAPI.dart';
import 'package:sales_automation/Components/Components.dart';
import 'package:sales_automation/Models/Cart.dart';
import 'package:sales_automation/Models/Item.dart';
import 'package:sales_automation/Screens/Order/OrderSummeryScreen.dart';
import 'package:sales_automation/global.dart';

class ItemsDetails extends StatefulWidget {
  const ItemsDetails({super.key});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  OrderAPI api = OrderAPI();
  List<Item> itemsWithCont = [];
  bool isLoading = true;

  @override
  void initState() {
    loadItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Add Item for ${selectedChemist.itemName}", 16,
              FontWeight.bold, Colors.black, TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                  visible: isLoading,
                  child: MyTextView("Loading products...", 16,
                      FontWeight.normal, Colors.black, TextAlign.center)),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemsWithCont!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextView(
                                itemsWithCont[index].itemName,
                                14,
                                FontWeight.normal,
                                Colors.black,
                                TextAlign.center),
                            SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: itemsWithCont[index].cont,
                                  keyboardType: TextInputType.number,
                                  onChanged: null,
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  calculatePrice();
                },
                child: MyTextView("Next", 12, FontWeight.bold, Colors.white,
                    TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadItem() async {
    itemsWithCont = await api.getItems();
    if (itemsWithCont.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculatePrice() {
    List<Cart> carts = [];

    for (int i = 0; i < itemsWithCont.length; i++) {
      if (itemsWithCont[i].cont.text.toString().isNotEmpty) {
        Cart cart = Cart(
            itemsWithCont[i].itemID,
            int.parse(itemsWithCont[i].cont.text.toString()),
            itemsWithCont[i].itemName,
            selectedChemist.itemName,
            0.0,
            selectedChemist.itemID);
        carts.add(cart);
      }
    }
    if (carts.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please pick item",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderSummeryScreen(carts: carts)));
    }
  }
}
