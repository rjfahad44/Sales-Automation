import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_automation/Models/LocationInfo.dart';
import '../global.dart';
import 'package:intl/intl.dart';

class AttendanceAPI {
  Future<String> submitAttendance(LocationInf locationInf) async {
    String now = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    String? deviceId = "";
    try{
      deviceId = await getDeviceId();
    }catch(e){
      print('deviceId error: $e');
    }

    Map map = {
      "id": userData.data.id,
      "employeeId": userData.data.employeeId,
      "date": now,
      "status": true,
      "isApproved": true,
      "latitude": locationInf.lat.toString(),
      "longitude": locationInf.lon.toString(),
      "address": locationInf.locationDetails,
      "deviceID": deviceId,
      "ip": "string"
    };
    print("attendance body : $map");

    final response = await http.post(
      Uri.parse('$serverPath/api/Attendances/SubmitAttendance'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
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
