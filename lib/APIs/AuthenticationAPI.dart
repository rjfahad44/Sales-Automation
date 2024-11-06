import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_automation/LocalDB/PrefsDb.dart';
import 'package:sales_automation/Models/UserData.dart';

import 'package:sales_automation/global.dart';

import '../Models/LoginApiResponse.dart';

class AuthenticationAPI {
  var prefs = PrefsDb();

  Future<bool> login(String userName, String password) async {
    var userNameAndPass = json.encode({PrefsDb.USER_ID: userName, PrefsDb.USER_PASS: password});
    var response = await http.post(
        Uri.parse("$serverPath/api/Login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: userNameAndPass,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print("jsonResponse : $jsonResponse \n");
      prefs.saveDataToSP(PrefsDb.USER_DATA, jsonResponse);
      prefs.saveDataToSP(PrefsDb.USER_NAME_AND_PASS, userNameAndPass);
      userData = LoginApiResponse.fromJson(jsonResponse);
      print("UserId : ${userData.data.id}");
      print("employeeId : ${userData.data.employeeId}");
      print("territoryId : ${userData.data.territoryId}");
      // tokenDecoder(userData.token);
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }
}

Map<String, dynamic> tokenDecoder(String token){
  Map<String, dynamic> payloadMap = {};
  if(token.length>5) {
    List<String> parts = token.split('.');
    String payload = parts[1];
    while (payload.length % 4 != 0) {
      payload += '=';
    }
    String decodedPayload = utf8.decode(base64Url.decode(payload));
    print("decodedPayload : $decodedPayload \n");
    payloadMap = jsonDecode(decodedPayload);
    print("payloadMap : $payloadMap \n");
  }
  return payloadMap;
}
