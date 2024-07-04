import 'package:hive/hive.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';

import '../../../global.dart';

@HiveType(typeId: order_model_type_id)
class OrderCreate {
  @HiveField(0) String deliveryDate;
  @HiveField(1) String deliveryTime;
  @HiveField(2) int chemistId;
  @HiveField(3) String chemist;
  @HiveField(4) String chemistAddress;
  @HiveField(5) String paymentType;
  @HiveField(6) List<Product> products;

  OrderCreate({
    this.deliveryDate = "",
    this.deliveryTime = "",
    this.chemistId = 0,
    this.chemist = "",
    this.chemistAddress = "",
    this.paymentType = "",
    List<Product>? products,
  }) : products = products ?? [];

  factory OrderCreate.fromJson(Map<String, dynamic> json) => OrderCreate(
    deliveryDate: json['deliveryDate'],
    deliveryTime: json['deliveryTime'],
    chemistId: json['chemistId'],
    chemist: json['chemist'],
    chemistAddress: json['chemistAddress'],
    paymentType: json['paymentType'],
    products: (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
  );

  Map<String, dynamic> toJson() => {
      'deliveryDate': deliveryDate,
      'deliveryTime': deliveryTime,
      'chemistId': chemistId,
      'chemist': chemist,
      'chemistAddress': chemistAddress,
      'paymentType': paymentType,
      'products': products.map((e) => e.toJson()).toList(),
    };

  double get totalAmount {
    return products.map((p) => p.tp * p.productQuantity).reduce((value, element) => value + element);
  }

  double get finalAmount {
    return products.map((p) => p.calculateFinalPrice(p.tp, p.productQuantity, p.discountValue, p.discountType, p.minimumQuantity)).reduce((value, element) => value + element);
  }

  double get totalDiscount {
    return totalAmount == finalAmount ? 0.0 : (totalAmount - finalAmount);
  }

  @override
  String toString() {
    return 'OrderCreate('
        'deliveryDate: $deliveryDate,'
        'deliveryTime: $deliveryTime'
        'chemistId: $chemistId'
        'chemist: $chemist'
        'chemistAddress: $chemistAddress'
        'paymentType: $paymentType'
        'products: $products'
        ')';
  }
}
