
import 'package:flutter/material.dart';
import 'package:sales_automation/Screens/DoctorListScreen/Model/Doctor.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';

import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../Models/Item.dart';
import '../../global.dart';

class ProductListScreen extends StatefulWidget{
  const ProductListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProductListScreenState();

}

class _ProductListScreenState extends State<ProductListScreen> {

  OrderAPI api = OrderAPI();
  List<Product> productList = [];

  @override
  void initState() {
    api.getProducts().then((value) {
      setState(() {
        productList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Products", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: productList.isNotEmpty? Column(
          children: [
            Expanded(
              child: ListView.builder(
                primary: true,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final data = productList[index];
                  return Card(
                    color: primaryButtonColor,
                    semanticContainer: true,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product id : ${data.id}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Product name : ${data.productName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Product price : ${data.price}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ): const Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }
}