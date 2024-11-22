// Main Order Data Model
class OrderHistoryData {
  final DateTime orderDate;
  final String orderNo;
  final int orderID;
  final String chemistName;
  final DateTime deliveryDate;
  final String deliveryShift;
  final String memoType;
  final double totalPrice;
  final List<OrderDetail> orderDetails;

  OrderHistoryData({
    required this.orderDate,
    required this.orderNo,
    required this.orderID,
    required this.chemistName,
    required this.deliveryDate,
    required this.deliveryShift,
    required this.memoType,
    required this.totalPrice,
    required this.orderDetails,
  });

  factory OrderHistoryData.fromJson(Map<String, dynamic> json) {
    return OrderHistoryData(
      orderDate: DateTime.parse(json['orderDate']),
      orderNo: json['orderNo'],
      orderID: json['orderID'],
      chemistName: json['chemistName'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryShift: json['deliveryShift'],
      memoType: json['memoType'],
      totalPrice: json['totalPrice'].toDouble(),
      orderDetails: (json['orderDetails'] as List)
          .map((e) => OrderDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderDate': orderDate.toIso8601String(),
      'orderNo': orderNo,
      'orderID': orderID,
      'chemistName': chemistName,
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryShift': deliveryShift,
      'memoType': memoType,
      'totalPrice': totalPrice,
      'orderDetails': orderDetails.map((e) => e.toJson()).toList(),
    };
  }
}

// Order Detail Data Model
class OrderDetail {
  final int orderID;
  final double discount;
  final double price;
  final int quantity;
  final String code;
  final String productName;
  final double totalDiscount;
  final double totalPrice;

  OrderDetail({
    required this.orderID,
    required this.discount,
    required this.price,
    required this.quantity,
    required this.code,
    required this.productName,
    required this.totalDiscount,
    required this.totalPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderID: json['orderID'],
      discount: json['discount'].toDouble(),
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      code: json['code'],
      productName: json['productName'],
      totalDiscount: json['totalDiscount'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'discount': discount,
      'price': price,
      'quantity': quantity,
      'code': code,
      'productName': productName,
      'totalDiscount': totalDiscount,
      'totalPrice': totalPrice,
    };
  }
}
