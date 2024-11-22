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

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      name: json['name'] ?? '',
      employeeID: json['employeeID'] ?? 0,
      date: DateTime.parse(json['date']),
      signInTime: json['signInTime'] ?? '',
      signOutTime: json['signOutTime'] ?? '',
      status: json['status'] ?? false,
      signInLatitude: (json['signInLatitude'] as num).toDouble(),
      signInLongitude: (json['signInLongitude'] as num).toDouble(),
      signOutLatitude: (json['signOutLatitude'] as num).toDouble(),
      signOutLongitude: (json['signOutLongitude'] as num).toDouble(),
      signInAddress: json['signInAddress'] ?? '',
      signOutAddress: json['signOutAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
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
}
