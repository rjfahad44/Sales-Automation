import 'dart:convert';
import 'dart:ffi';
import '../global.dart';
import 'package:http/http.dart' as http;

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
    final resp = json.decode(response.body);
    print('resp : ${resp}');
    // final items = resp['data'] as List<dynamic>;
    // return items.map((jsonItem) => Item.fromJson(jsonItem)).toList();
  } else {
    print('Failed to load visit List');
  }
}