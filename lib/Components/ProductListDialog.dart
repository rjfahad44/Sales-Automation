
import 'package:flutter/material.dart';
import 'package:sales_automation/global.dart';

import '../Screens/ImageCaptureScreen/Model/ImageUploadResponse.dart';
import '../Screens/ProductListScreen/Model/Product.dart';
import 'Components.dart';

Future<T?> showProductListDialog<T>(
    BuildContext context,
    List<Product> productList,
    Function(List<Product> productList) callBack) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ProductListDialog(productList: productList, callBack: callBack,);
    },
  );
}

class ProductListDialog extends StatefulWidget{

  List<Product> productList;
  Function(List<Product> productList) callBack;

  ProductListDialog({super.key, required this.productList, required this.callBack, });

  @override
  State<StatefulWidget> createState() => _BuildProductListDialogState();

}

class _BuildProductListDialogState extends State<ProductListDialog>{

  List<Product> productSearchList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    productSearchList = widget.productList;
    _searchController.addListener(_filterItems);
    super.initState();
  }

  void _filterItems() {
    final query = _searchController.text.toUpperCase();
    setState(() {
      if (query.isEmpty) {
        widget.productList = productSearchList; // Reset to original list
      } else {
        widget.productList = productSearchList.where((item) {
          return (item.productName.toUpperCase().contains(query) ||
              item.id.toString().contains(query));
        }).toList();
      }
    });
  }

  void _getAllSelectedProducts(){
    List<Product> selectedProductList = [];
    for (var product in productSearchList.where((product) => product.textEditingController.text.isNotEmpty)) {
      selectedProductList.add(Product(
        id: product.id,
        productId: product.productId,
        productCode: product.productCode,
        productName: product.productName,
        tp: product.tp,
        productQuantity: int.parse(product.textEditingController.text),
        productShortName: product.productShortName,
        packSize: product.packSize,
        discountName: product.discountName,
        discountType: product.discountType,
        discountValue: product.discountValue,
        minimumQuantity: product.minimumQuantity,
        description: product.description,
        vat: product.vat,
        mrp: product.mrp,
      ));
    }
    widget.callBack(selectedProductList);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(10.0),
        // decoration: const BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(12.0),
        //     topRight: Radius.circular(12.0),
        //     bottomLeft: Radius.circular(0),
        //     bottomRight: Radius.circular(0),
        //   ),
        // ),
        child: Column(
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
                itemCount: widget.productList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: primaryButtonColor,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Product Name
                          Expanded(
                            flex: 3,
                            child: Text(
                              widget.productList[index].productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0,
                              ),
                            ),
                          ),

                          // Product Price
                          Flexible(
                            flex: 2,
                            child: Text(
                              "Price: ${widget.productList[index].tp}৳",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0,
                              ),
                            ),
                          ),

                          // Quantity Input
                          SizedBox(
                            width: 80, // Set a fixed width to prevent overflow
                            child: TextField(
                              controller: widget.productList[index].textEditingController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
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
                              onChanged: (value) {
                                // Handle quantity change here, if needed
                              },
                            ),
                          ),
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                minimumSize: const Size(0, 50),
                backgroundColor: primaryButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: _getAllSelectedProducts,
              child: MyTextView("Done", 16, FontWeight.bold, Colors.white,
                  TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}