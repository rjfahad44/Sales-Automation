import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart';

import '../Screens/DcrScreen/Models/DoctorPlanResponse.dart';
import '../global.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PlanApis{

  getPlansToVisitList(String onDate, Function(Response response) responseCallback) async {
    final response = await http.get(
      Uri.parse(
          '$serverPath/api/Plans/tovisit?onDate=${onDate}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
      },
    );
    responseCallback.call(response);
  }

  doctorVisitSubmit(
      int doctorId,
      String accompany,
      String promote,
      String remarks,
      int sampleQty,
      int giftQty,
      int lituratureQty,
      Function (Response response) responseCallback
      ) async {
    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map bodyMap = {
      "DoctorID": doctorId,
      "TerritoryId": userData.data.territoryId,
      "MioID": userData.data.employeeId,
      "Accompany": accompany,
      "Promote": promote,
      "Remarks": remarks,
      "SampleQty": sampleQty,
      "GiftQty": giftQty,
      "LituratureQty": lituratureQty,
      "Shift": 2,
      "Latitude": locationInf.lat,
      "Longitude": locationInf.lon
    };

    final response = await http.post(
      Uri.parse('$serverPath/api/DoctorVisit/SubmitVisit'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
      },
      body: jsonEncode(bodyMap),
    );

    print("Request Body : ${bodyMap}");

    responseCallback.call(response);
  }
}
