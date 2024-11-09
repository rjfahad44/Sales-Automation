

class DoctorPlan {
  final int planId;
  final String doctorName;
  final String designation;
  final String doctorAddress;
  final int samples;
  final int giftId;
  final int literatureID;
  final int doctorID;
  final DateTime date;
  final int employeeId;
  final String shift;
  final bool isVisited;

  DoctorPlan({
    required this.planId,
    required this.doctorName,
    required this.designation,
    required this.doctorAddress,
    required this.samples,
    required this.giftId,
    required this.literatureID,
    required this.doctorID,
    required this.date,
    required this.employeeId,
    required this.shift,
    required this.isVisited,
  });

  factory DoctorPlan.fromJson(Map<String, dynamic> json) {
    return DoctorPlan(
      planId: json['planId'],
      doctorName: json['doctorName'],
      designation: json['designation'] ?? '',
      doctorAddress: json['doctorAddress'],
      samples: json['samples'],
      giftId: json['giftId'],
      literatureID: json['literatureID'],
      doctorID: json['doctorID'],
      date: DateTime.parse(json['date']),
      employeeId: json['employeeId'],
      shift: json['shift'],
      isVisited: json['isVisited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'doctorName': doctorName,
      'designation': designation,
      'doctorAddress': doctorAddress,
      'samples': samples,
      'giftId': giftId,
      'literatureID': literatureID,
      'doctorID': doctorID,
      'date': date.toIso8601String(),
      'employeeId': employeeId,
      'shift': shift,
      'isVisited': isVisited,
    };
  }
}