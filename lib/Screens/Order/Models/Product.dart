
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../../global.dart';

@HiveType(typeId: product_model_type_id)
class Product {
  @HiveField(0)
  int id;
  @HiveField(1)
  String productCode;
  @HiveField(2)
  String productName;
  @HiveField(3)
  double price;
  @HiveField(4)
  int productQuantity;
  TextEditingController textEditingController;

  Product({
    this.id = 0,
    this.productCode = "",
    this.productName = "",
    this.price = 0,
    this.productQuantity = 0,
    TextEditingController? textEditingController,
  }) : textEditingController = textEditingController ?? TextEditingController();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      productCode: json['productCode'] as String,
      productName: json['productName'] as String,
      price: json['price'] as double,
      productQuantity: 0,
      textEditingController: TextEditingController(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productCode': productCode,
    'productName': productName,
    'price': price,
    'productQuantity': productQuantity,
  };

  @override
  String toString() {
    return 'Product('
        'id: $id,'
        'productCode: $productCode'
        'productName: $productName'
        'price: $price'
        'productQuantity: $productQuantity'
        ')';
  }
}
