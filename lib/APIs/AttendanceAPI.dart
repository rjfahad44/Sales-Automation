import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_automation/Models/LocationInfo.dart';
import '../global.dart';
import 'package:intl/intl.dart';

class AttendanceAPI {
  Future<String> submitAttendance(LocationInf locationInf) async {
    String now =
        DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now()) + 'Z';

    Map map = {
      "employeeID": currentLoginUser.userID,
      "date": now,
      "status": true,
      "isApproved": true,
      "signInLatitude": locationInf.lat.toString(),
      "signInLongitude": locationInf.lon.toString(),
      "signInAddress": "string",
      "signOutLatitude": locationInf.lat.toString(),
      "signOutLongitude": locationInf.lon.toString(),
      "signOutAddress": "string",
      "deviceID": "string",
      "ip": "string"
    };


    // {
    //   "employeeID": currentLoginUser.userID,
    //   "date": now,
    //   "signInTime": now,
    //   "signOutTime": now,
    //   "status": true,
    //   "isApproved": true,
    //   "signInLatitude": locationInf.lat.toString(),
    //   "signInLongitude": locationInf.lon.toString(),
    //   "signInAddress": locationInf.locationDetails,
    //   "signOutLatitude": locationInf.lat.toString(),
    //   "signOutLongitude": locationInf.lon.toString(),
    //   "signOutAddress": locationInf.locationDetails,
    //   "deviceID": "string",
    //   "ip": "string"
    // };

    final response = await http.post(
      Uri.parse('${serverPath}/api/Attendances/SubmitAttendance'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(map),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = json.decode(response.body);

      return jsonMap["message"];
    } else {
      return "Failed to submit";
    }
  }
}
