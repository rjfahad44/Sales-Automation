
import 'DoctorPlan.dart';

class DoctorPlanResponse {
  final List<DoctorPlan> data;
  final bool success;
  final dynamic exception;
  final int messageType;
  final int count;
  final String message;
  final DateTime dateTime;

  DoctorPlanResponse({
    required this.data,
    required this.success,
    required this.exception,
    required this.messageType,
    required this.count,
    required this.message,
    required this.dateTime,
  });

  factory DoctorPlanResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<DoctorPlan> dataList = list.map((i) => DoctorPlan.fromJson(i)).toList();

    return DoctorPlanResponse(
      data: dataList,
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
      'data': data.map((v) => v.toJson()).toList(),
      'success': success,
      'exception': exception,
      'messageType': messageType,
      'count': count,
      'message': message,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}