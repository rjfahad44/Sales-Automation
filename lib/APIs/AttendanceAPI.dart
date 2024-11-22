import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:sales_automation/Models/LocationInfo.dart';
import '../Models/AttendanceData.dart';
import '../global.dart';
import 'package:intl/intl.dart';

class AttendanceAPI {
  Future<bool> submitAttendance(LocationInf currentLocation) async {
    String now =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    String? deviceId = "";
    try {
      deviceId = await getDeviceId();
    } catch (e) {
      print('deviceId error: $e');
    }

    Map map = {
      "id": userData.data.id,
      "employeeId": userData.data.employeeId,
      "date": now,
      "status": true,
      "isApproved": true,
      "latitude": "${currentLocation.lat}",
      "longitude": "${currentLocation.lon}",
      "address": "${currentLocation.locationName ?? currentLocation.locationDetails}",
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

      return true;
    } else {
      return false;
    }
  }

  Future<List<AttendanceData>?> getEmployeeAttendance(DateTime? fromDate, DateTime? toDate) async {
    final String fromDateString = DateFormat("yyyy-MM-dd").format(fromDate ?? DateTime.now());
    final String toDateString = DateFormat("yyyy-MM-dd").format(toDate ?? DateTime.now());
    final String url = '$serverPath/api/Attendances/GetEmployeeWiseAttendanceListByEmployeeId?employeeId=${userData.data.employeeId}&fromDate=$fromDateString&toDate=$toDateString';

    try {
      final Uri uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer ${userData.data.token}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        debugPrint("Attendance History: $jsonData");

        // Ensure data is parsed as a list
        if (jsonData['data'] is List) {
          final List<dynamic> jsonList = jsonData['data'];

          // Map to AttendanceData objects
          final List<AttendanceData> attendanceList = jsonList
              .map((item) => AttendanceData.fromJson(item as Map<String, dynamic>))
              .toList();

          return attendanceList;
        } else {
          debugPrint("Error: 'data' is not a List. Actual type: ${jsonData['data'].runtimeType}");
          return null;
        }
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      debugPrint("Exception occurred: $e");
      return null;
    }
  }
}
