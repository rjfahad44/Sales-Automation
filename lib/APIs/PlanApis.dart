import 'dart:convert';
import 'dart:ffi';
import '../global.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PlanApis{

  getPlansToVisitList(String fromDate, String toDate) async {
    final response = await http.get(
      Uri.parse(
          '$serverPath/api/Plans/tovisit?fromDate=${fromDate}&ToDate=${toDate}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.statusCode == 200) {
      final resp = jsonDecode(response.body);
      print('resp : ${resp}');
      // final items = resp['data'] as List<dynamic>;
      // return items.map((jsonItem) => Item.fromJson(jsonItem)).toList();
    } else {
      print('Failed to load visit List');
    }
  }

  doctorVisitSubmit() async {
    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map bodyMap = {
      "DoctorID": 120,
      "TerritoryId": userData.territoryId,
      "MioID": 77,
      "Accompany": "Yes",
      "Promote": "Promotion",
      "Remarks": "Remarks here",
      "SampleQty": 1,
      "GiftQty": 2,
      "LituratureQty": 1,
      "Shift": 2,
      "Latitude": locationInf.lat,
      "Longitude": locationInf.lon
    };

    final response = await http.post(
      Uri.parse('$serverPath/api/DoctorVisit/SubmitVisit'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
      body: jsonEncode(bodyMap),
    );

    print("Request Body : ${bodyMap}");

    if (response.statusCode == 200) {
      var resp = jsonDecode(response.body);
      print('resp: ${resp}');
    } else {
      print('Failed : ${response.toString()}');
    }
  }
}
