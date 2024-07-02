
import 'package:flutter/cupertino.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<Product> productList = [];
  List<Product> productSearchList = [];
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

              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _searchController,
                  style:  const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: primaryButtonColor,),
                    labelText: 'Search..',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: primaryButtonColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: primaryButtonColor, width: 2.0), // Set the focused border color to blue
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: primaryButtonColor), // Set the enabled border color to blue
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: primaryButtonColor,
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextView(
                                productList[index].productName,
                                12,
                                FontWeight.normal,
                                Colors.white,
                                TextAlign.center),
                            MyTextView("Price: ${productList[index].tp}৳", 12, FontWeight.normal, Colors.white, TextAlign.center),
                            SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: productList[index].textEditingController,
                                  keyboardType: TextInputType.number,
                                  style:  const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: 'Quantity',
                                    hintStyle: const TextStyle(color: Colors.white70, fontSize: 11.0),
                                    filled: true,
                                    fillColor: Colors.blue[900],
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onChanged: null,
                                ),
                            )
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

  void _filterItems() {
    final query = _searchController.text.toUpperCase();
    setState(() {
      productList = productSearchList.where((item) {
        return (item.productName.toUpperCase().contains(query) || item.id.toString().contains(query));
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
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
        productSearchList = productList;
        _searchController.addListener(_filterItems);
      }
    });
  }

  void calculatePrice() {
    List<Cart> carts = [];
    orderCreate.products.clear();
    for (var product in productList.where((product) => product.textEditingController.text.isNotEmpty)) {
      Cart cart = Cart(
        product.id,
        product.productName,
        product.tp,
        int.parse(product.textEditingController.text),
        product.discountName,
        product.discountType,
        product.discountValue,
        product.minimumQuantity,
        product.vat,
        product.mrp,
        selectedChemist.itemName,
        selectedChemist.itemID,
      );
      print("Selected Item : ${cart.quantity}");
      orderCreate.products.add(
        Product(
          id: product.id,
          productCode: product.productCode,
          productName: product.productName,
          tp: product.tp,
          productQuantity: cart.quantity,
          productShortName: product.productShortName,
          packSize: product.packSize,
          discountName: product.discountName,
          discountType: product.discountType,
          discountValue: product.discountValue,
          minimumQuantity: product.minimumQuantity,
          description: product.description,
          vat: product.vat,
          mrp: product.mrp
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
