
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
  final TextEditingController _searchController = TextEditingController();
  List<Product> productList = [];
  List<Product> productSearchList = [];
  bool isLoading = false;

  @override
  void initState() {
    api.getProducts().then((value) {
      setState(() {
        productList = value;
        productSearchList = value;
        _searchController.addListener(_filterItems);
        isLoading = true;
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
        body: isLoading?
        Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 4.0,
                right: 4.0,
                bottom: 4.0
              ),
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
                    borderSide: BorderSide(color: primaryButtonColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: primaryButtonColor),
                  ),
                ),
              ),
            ),

            productList.isNotEmpty?
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
                            "Product price : ${data.tp}৳",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            "Discount : ${data.discountValue}${data.discountType.toLowerCase() == 'percentage'? "%" : "৳"}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            "Minimum price for applicable discount: ${data.minimumQuantity}৳",
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
            ):
            Center(
              child: MyTextView("No Data Found!", 18, FontWeight.bold,
                  Colors.black, TextAlign.center),
            ),

          ],
        ): const Center(
          child: CircularProgressIndicator()
        ),
      ),
    );
  }

  void _filterItems() {
    final query = _searchController.text.toUpperCase();
    setState(() {
      productList = productSearchList.where((item) { return (item.productName.toUpperCase().contains(query) || item.id.toString().contains(query)); }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }
}