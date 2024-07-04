
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../../global.dart';

@HiveType(typeId: product_model_type_id)
class Product {
  @HiveField(0)   int id;
  @HiveField(1)   String productCode;
  @HiveField(2)   String productName;
  @HiveField(3)   double tp;
  @HiveField(4)   String productShortName;
  @HiveField(5)   String packSize;
  @HiveField(6)   String discountName;
  @HiveField(7)   double discountValue;
  @HiveField(8)   int minimumQuantity;
  @HiveField(9)   String discountType;
  @HiveField(10)  String description;
  @HiveField(11)  double vat;
  @HiveField(12)  double mrp;
  @HiveField(13)   int productQuantity;
  TextEditingController textEditingController;

  Product({
    this.id = 0,
    this.productCode = "",
    this.productName = "",
    this.tp = 0.0,
    this.productShortName = "",
    this.packSize = "",
    this.discountName = "",
    this.discountValue = 0.0,
    this.minimumQuantity = 0,
    this.discountType = "",
    this.description = "",
    this.vat = 0.0,
    this.mrp = 0.0,
    this.productQuantity = 0,
    TextEditingController? textEditingController,
  }) : textEditingController = textEditingController ?? TextEditingController();



  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productCode: json['productCode'],
      productName: json['productName'],
      tp: json['tp'],
      productShortName: json['productShortName'],
      packSize: json['packSize'],
      discountName: json['discountName'],
      discountValue: json['discountValue'],
      minimumQuantity: json['minimumQuantity'],
      discountType: json['discountType'],
      description: json['description'],
      vat: json['vat'],
      mrp: json['mrp'],
      productQuantity: 0,
      textEditingController: TextEditingController(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productCode': productCode,
    'productName': productName,
    'tp': tp,
    'productShortName': productShortName,
    'packSize': packSize,
    'discountName': discountName,
    'discountValue': discountValue,
    'minimumQuantity': minimumQuantity,
    'discountType': discountType,
    'description': description,
    'vat': vat,
    'mrp': mrp,
    'productQuantity': productQuantity,
  };

  @override
  String toString() {
    return 'Product('
        'id: $id'
        'productCode: $productCode'
        'productName: $productName'
        'tp: $tp'
        'productShortName: $productShortName'
        'packSize: $packSize'
        'discountName: $discountName'
        'discountValue: $discountValue'
        'minimumQuantity: $minimumQuantity'
        'discountType: $discountType'
        'description: $description'
        'vat: $vat'
        'mrp: $mrp'
        'productQuantity: $productQuantity'
        ')';
  }


  double calculateFinalPrice(double productPrice, int quantity, double discountValue, String discountType, int minimumQuantity) {
    double totalPrice = productPrice * quantity;
    if (totalPrice < minimumQuantity) return totalPrice;
    return discountType.toLowerCase() == 'percentage'
        ? totalPrice * (1 - discountValue / 100)
        : totalPrice - discountValue;
  }

  double calculateDiscount(double productPrice, int quantity, double discountValue, String discountType, int minimumQuantity){
    double totalPrice = productPrice * quantity;
    if (totalPrice >= minimumQuantity) {
      return discountType.toLowerCase() == 'percentage'
          ? totalPrice * (1 - discountValue / 100)
          : totalPrice - discountValue;
    } else {
      return 0;
    }
  }
}
