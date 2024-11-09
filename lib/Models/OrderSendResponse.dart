

class OrderSendResponse {
  final Order data;
  final bool success;
  final dynamic exception;
  final int messageType;
  final int count;
  final String message;
  final DateTime dateTime;

  OrderSendResponse({
    required this.data,
    required this.success,
    this.exception,
    required this.messageType,
    required this.count,
    required this.message,
    required this.dateTime,
  });

  factory OrderSendResponse.fromJson(Map<String, dynamic> json) {
    return OrderSendResponse(
      data: Order.fromJson(json['data']),
      success: json['success'],
      exception: json['exception'],
      messageType: json['messageType'],
      count: json['count'],
      message: json['message'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'success': success,
      'exception': exception,
      'messageType': messageType,
      'count': count,
      'message': message,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

class Order {
  final int id;
  final DateTime orderDate;
  final String orderNo;
  final int chemistId;
  final String? chemistName;
  final String? chemistCode;
  final double total;
  final String? address;
  final String? contactNo;
  final List<OrderDetail> orderDetails;

  Order({
    required this.id,
    required this.orderDate,
    required this.orderNo,
    required this.chemistId,
    this.chemistName,
    this.chemistCode,
    required this.total,
    this.address,
    this.contactNo,
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var orderDetailsFromJson = json['orderDetails'] as List;
    List<OrderDetail> orderDetailsList = orderDetailsFromJson.map((i) => OrderDetail.fromJson(i)).toList();

    return Order(
      id: json['id'],
      orderDate: DateTime.parse(json['orderDate']),
      orderNo: json['orderNo'],
      chemistId: json['chemistId'],
      chemistName: json['chemistName'],
      chemistCode: json['chemistCode'],
      total: json['total'].toDouble(),
      address: json['address'],
      contactNo: json['contactNo'],
      orderDetails: orderDetailsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'orderNo': orderNo,
      'chemistId': chemistId,
      'chemistName': chemistName,
      'chemistCode': chemistCode,
      'total': total,
      'address': address,
      'contactNo': contactNo,
      'orderDetails': orderDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderDetail {
  final int id;
  final int orderId;
  final int productId;
  final String? productName;
  final int quantity;
  final double amount;
  final double discountValue;
  final String discountName;
  final String discountType;
  final int minimumQuantity;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.productId,
    this.productName,
    required this.quantity,
    required this.amount,
    required this.discountValue,
    required this.discountName,
    required this.discountType,
    required this.minimumQuantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      amount: json['amount'].toDouble(),
      discountValue: json['discountValue'].toDouble(),
      discountName: json['discountName'],
      discountType: json['discountType'],
      minimumQuantity: json['minimumQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'amount': amount,
      'discountValue': discountValue,
      'discountName': discountName,
      'discountType': discountType,
      'minimumQuantity': minimumQuantity,
    };
  }
}
