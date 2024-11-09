


class ProductsApiResponse<T>{
  List<T>? data;
  bool success;
  dynamic exception;
  int messageType;
  int count;
  String message;
  DateTime dateTime;

  ProductsApiResponse({
    this.data,
    this.success = false,
    this.exception = "",
    this.messageType = 0,
    this.count = 0,
    this.message = '',
    DateTime? dateTime,
  })  : dateTime = dateTime ?? DateTime.now();

  factory ProductsApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return ProductsApiResponse<T>(
      data: json['data'] != null
          ? List<T>.from(json['data'].map((item) => fromJsonT(item)))
          : null,
      success: json['success'],
      exception: json['exception'],
      messageType: json['messageType'],
      count: json['count'],
      message: json['message'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  // Method to convert ProductsApiResponse with List<T> data to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'data': data?.map((item) => toJsonT(item)).toList(),
    'success': success,
    'exception': exception,
    'messageType': messageType,
    'count': count,
    'message': message,
    'dateTime': dateTime.toIso8601String(),
  };
}