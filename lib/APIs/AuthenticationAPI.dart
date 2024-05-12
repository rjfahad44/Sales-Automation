import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:sales_automation/global.dart';

class AuthenticationAPI {


  Future<bool> login(String userName, String password) async {
    var url = Uri.parse("${serverPath}/api/login");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json', // Set the content type here
        },
        body: json.encode({"userName": userName, "password": password}));
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      token = jsonResponse["data"]["token"];
      currentLoginUser.token = token;
      if(token.length>5){
        List<String> parts = token.split('.');
        String payload = parts[1];
        while (payload.length % 4 != 0) {
          payload += '=';
        }
        String decodedPayload = utf8.decode(base64Url.decode(payload));
        Map<String, dynamic> payloadMap = json.decode(decodedPayload);
        currentLoginUser.userID = int.parse(payloadMap["EmployeeId"]);
        return true;
      } else {
        return false;
      }

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return false;
  }
}
