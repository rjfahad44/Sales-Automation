import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_automation/LocalDB/PrefsDb.dart';
import 'package:sales_automation/Models/UserData.dart';
import 'dart:convert' as convert;

import 'package:sales_automation/global.dart';

class AuthenticationAPI {
  var prefs = PrefsDb();


  Future<bool> login(String userName, String password) async {
    var userNameAndPass = json.encode({PrefsDb.USER_NAME: userName, PrefsDb.USER_PASS: password});
    var response = await http.post(
        Uri.parse("$serverPath/api/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: userNameAndPass,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      prefs.saveDataToSP(PrefsDb.USER_DATA, jsonResponse);
      prefs.saveDataToSP(PrefsDb.USER_NAME_AND_PASS, userNameAndPass);
      userData = UserData.fromJson(jsonResponse);
      print("UserId : ${userData.id}");
      print("employeeId : ${userData.employeeId}");
      // var token = jsonResponse["data"]["token"];
      // if(token.length>5){
      //   List<String> parts = token.split('.');
      //   String payload = parts[1];
      //   while (payload.length % 4 != 0) {
      //     payload += '=';
      //   }
      //   String decodedPayload = utf8.decode(base64Url.decode(payload));
      //   Map<String, dynamic> payloadMap = json.decode(decodedPayload);
      //   var userId = int.parse(payloadMap["EmployeeId"]);
      //   print("EmployeeId : ${userId}");
      //   return true;
      // } else {
      //   return false;
      // }
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }
}
