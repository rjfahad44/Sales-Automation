import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Models/Cart.dart';
import '../Models/Item.dart';
import '../Screens/Order/Models/Product.dart';
import '../global.dart';
import 'package:intl/intl.dart';

class OrderAPI {

  Future<List<Product>> getProducts() async {

    final response = await http.get(
      Uri.parse('$serverPath/api/Products'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    print("--------------------------");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final productsList = res['data'] as List<dynamic>;
      return productsList.map((jsonItem) => Product.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Item>> getItems() async {

    final response = await http.get(
      Uri.parse('$serverPath/api/Products/Dropdowns'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    print("--------------------------");
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      final items = resp['data'] as List<dynamic>;
      return items.map((jsonItem) => Item.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Item>> getChemistListForDropdown() async {
    final response = await http.get(
      Uri.parse('$serverPath/api/Chemists/ChemistListForDropdowns?id=${userData.territoryId}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      final items = resp['data'] as List<dynamic>;
      return items.map((jsonItem) => Item.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<double> getItemPrice(int itemID) async {
    final response = await http.get(
      Uri.parse('$serverPath/api/Products/ById?id=$itemID'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      if (resp["data"]["price"].runtimeType == double) {
        return resp["data"]["price"];
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }

  Future<bool> submitOrder(List<Cart> carts) async {
    List<Map> itemsListJson = [];
    for (int i = 0; i < carts.length; i++) {
      itemsListJson.add({
        "id": 0,
        "orderId": 0,
        "productId": carts[i].itemID,
        "quantity": carts[i].quantity,
        "amount": (carts[i].quantity * carts[i].unitPrice)
      });
    }

    String now = '${DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now())}Z';
    Map map = {
      "orderDate": now,
      "orderNo": "1",
      "chemistId": carts[0].chemistID,
      "orderDetails": itemsListJson
    };

    final response = await http.post(
      Uri.parse('$serverPath/api/Order'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
      body: jsonEncode(map),
    );


    print("-------------------OrderCreate------------------------");
    print("Request Body : ${jsonEncode(map)}");
    print(response.body);

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      return resp["success"];
    } else {
      return false;
    }
  }
}
