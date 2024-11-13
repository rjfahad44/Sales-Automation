

class OrderResponse {
  final OrderData data;
  final bool success;
  final dynamic exception;
  final int messageType;
  final int count;
  final String message;
  final DateTime dateTime;

  OrderResponse({
    required this.data,
    required this.success,
    this.exception,
    required this.messageType,
    required this.count,
    required this.message,
    required this.dateTime,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      data: OrderData.fromJson(json['data']),
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


class OrderData {
  final int id;
  final DateTime orderDate;
  final int orderNo;
  final int orderID;
  final int chemistId;
  final String chemistName;
  final String chemistCode;
  final double total;
  final String? address;
  final String? contactNo;
  final List<OrderDetail> orderDetails;

  OrderData({
    required this.id,
    required this.orderDate,
    required this.orderNo,
    required this.orderID,
    required this.chemistId,
    required this.chemistName,
    required this.chemistCode,
    required this.total,
    this.address,
    this.contactNo,
    required this.orderDetails,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      orderDate: DateTime.parse(json['orderDate']),
      orderNo: json['orderNo'],
      orderID: json['orderID'],
      chemistId: json['chemistId'],
      chemistName: json['chemistName'] ?? '',
      chemistCode: json['chemistCode'] ?? '',
      total: (json['total'] as num).toDouble(),
      address: json['address'],
      contactNo: json['contactNo'],
      orderDetails: (json['orderDetails'] as List).map((detail) => OrderDetail.fromJson(detail)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'orderNo': orderNo,
      'orderID': orderID,
      'chemistId': chemistId,
      'chemistName': chemistName,
      'chemistCode': chemistCode,
      'total': total,
      'address': address,
      'contactNo': contactNo,
      'orderDetails': orderDetails.map((detail) => detail.toJson()).toList(),
    };
  }
}


class OrderDetail {
  final int productId;
  final int quantity;

  OrderDetail({
    required this.productId,
    required this.quantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

