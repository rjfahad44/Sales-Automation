import 'package:hive/hive.dart';
import 'package:sales_automation/Screens/Order/Models/Product.dart';

import '../../../global.dart';

@HiveType(typeId: order_model_type_id)
class OrderCreate {
  @HiveField(0)
  String deliveryDate;
  @HiveField(1)
  String deliveryTime;
  @HiveField(2)
  String chemist;
  @HiveField(3)
  String chemistAddress;
  @HiveField(4)
  String paymentType;
  @HiveField(5)
  List<Product> products;

  OrderCreate({
    this.deliveryDate = '',
    this.deliveryTime = '',
    this.chemist = '',
    this.chemistAddress = '',
    this.paymentType = '',
    List<Product>? products,
  }) : products = products ?? [];

  factory OrderCreate.fromJson(Map<String, dynamic> json) => OrderCreate(
    deliveryDate: json['deliveryDate'],
    deliveryTime: json['deliveryTime'],
    chemist: json['chemist'],
    chemistAddress: json['chemistAddress'],
    paymentType: json['paymentType'],
    products: (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
  );

  Map<String, dynamic> toJson() => {
      'deliveryDate': deliveryDate,
      'deliveryTime': deliveryTime,
      'chemist': chemist,
      'chemistAddress': chemistAddress,
      'paymentType': paymentType,
      'products': products.map((e) => e.toJson()).toList(),
    };

  @override
  String toString() {
    return 'OrderCreate('
        'deliveryDate: $deliveryDate,'
        'deliveryTime: $deliveryTime'
        'chemist: $chemist'
        'chemistAddress: $chemistAddress'
        'paymentType: $paymentType'
        'products: $products'
        ')';
  }
}
