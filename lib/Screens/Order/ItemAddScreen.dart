
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_automation/APIs/OrderAPI.dart';
import 'package:sales_automation/Components/Components.dart';
import 'package:sales_automation/Models/Cart.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';
import 'package:sales_automation/Screens/Order/OrderSummeryScreen.dart';
import 'package:sales_automation/global.dart';

class ItemsDetails extends StatefulWidget {
  const ItemsDetails({super.key});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  OrderAPI api = OrderAPI();
  List<Product> productList = [];
  bool isLoading = true;

  @override
  void initState() {
    loadProducts();
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
          child: isLoading? Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextView(
                                productList[index].productName,
                                14,
                                FontWeight.normal,
                                Colors.black,
                                TextAlign.center),
                            SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: productList[index].textEditingController,
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
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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

  Future<void> loadProducts() async {
    productList = await api.getProducts();
    setState(() {
      if (productList.isNotEmpty) {
        for (int i=0; i<orderCreate.products.length; i++) {
          try{
            int pos= productList.indexWhere((item) => item.id == orderCreate.products[i].id);
            print("Product position : ${pos}");
            print("Product : ${productList[pos]}");
            productList[pos].textEditingController.text = "${orderCreate.products[i].productQuantity}";
          }catch(e){
            print(e);
          }
        }
        isLoading = false;
      }
    });
  }

  void calculatePrice() {
    List<Cart> carts = [];
    orderCreate.products.clear();
    for (var product in productList.where((product) => product.textEditingController.text.isNotEmpty)) {
      Cart cart = Cart(
        product.id,
        int.parse(product.textEditingController.text),
        product.productName,
        selectedChemist.itemName,
        product.price,
        selectedChemist.itemID,
      );
      print("Selected Item : ${cart.quantity}");
      orderCreate.products.add(
        Product(
          id: product.id,
          productCode: product.productCode,
          productName: product.productName,
          price: product.price,
          productQuantity: cart.quantity
        )
      );
      carts.add(cart);
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
