import 'dart:convert';

class AttendanceData {
  final String name;
  final int employeeID;
  final DateTime date;
  final String signInTime;
  final String signOutTime;
  final bool status;
  final double signInLatitude;
  final double signInLongitude;
  final double signOutLatitude;
  final double signOutLongitude;
  final String signInAddress;
  final String signOutAddress;

  AttendanceData({
    required this.name,
    required this.employeeID,
    required this.date,
    required this.signInTime,
    required this.signOutTime,
    required this.status,
    required this.signInLatitude,
    required this.signInLongitude,
    required this.signOutLatitude,
    required this.signOutLongitude,
    required this.signInAddress,
    required this.signOutAddress,
  });

  // Factory method to create an instance from a map
  factory AttendanceData.fromMap(Map<String, dynamic> map) {
    return AttendanceData(
      name: map['name'] as String,
      employeeID: map['employeeID'] as int,
      date: DateTime.parse(map['date'] as String),
      signInTime: map['signInTime'] as String,
      signOutTime: map['signOutTime'] as String,
      status: map['status'] as bool,
      signInLatitude: (map['signInLatitude'] as num).toDouble(),
      signInLongitude: (map['signInLongitude'] as num).toDouble(),
      signOutLatitude: (map['signOutLatitude'] as num).toDouble(),
      signOutLongitude: (map['signOutLongitude'] as num).toDouble(),
      signInAddress: map['signInAddress'] as String,
      signOutAddress: map['signOutAddress'] as String,
    );
  }

  // Method to convert the instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'employeeID': employeeID,
      'date': date.toIso8601String(),
      'signInTime': signInTime,
      'signOutTime': signOutTime,
      'status': status,
      'signInLatitude': signInLatitude,
      'signInLongitude': signInLongitude,
      'signOutLatitude': signOutLatitude,
      'signOutLongitude': signOutLongitude,
      'signInAddress': signInAddress,
      'signOutAddress': signOutAddress,
    };
  }

  // Factory method to create a list of EmployeeData from JSON
  static List<AttendanceData> fromJson(String source) {
    final data = json.decode(source) as List<dynamic>;
    return data.map((item) => AttendanceData.fromMap(item as Map<String, dynamic>)).toList();
  }

  // Method to convert a list of EmployeeData to JSON
  static String toJson(List<AttendanceData> data) {
    return json.encode(data.map((item) => item.toMap()).toList());
  }
}
