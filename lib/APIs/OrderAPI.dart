import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sales_automation/Screens/DoctorListScreen/Model/Doctor.dart';

import '../Models/Cart.dart';
import '../Models/Item.dart';
import '../Screens/Order/Models/OrderCreate.dart';
import '../Screens/Order/Models/OrderSendResponse.dart';
import '../Screens/ProductListScreen/Model/Product.dart';
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
      Uri.parse('$serverPath/api/Chemists/ChemistListForDropdowns?id=${userData.id}'),
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
      throw Exception('Failed to load Chemist List');
    }
  }

  Future<List<Doctor>> getDoctorList() async {
    final response = await http.get(
      Uri.parse('$serverPath/api/Doctor/TerritoryWiseDoctorList?territoryID=${userData.territoryId}'),
      headers: {
        "accept": "*/*",
        "Authorization": "Bearer ${userData.token}",
      },
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      final items = resp['data'] as List<dynamic>;
      return items.map((jsonItem) => Doctor.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load Doctor List');
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

  submitOrder(List<Cart> carts, Function(bool isSuccess, OrderSendResponse response) callBack) async {
    List<Map> itemsListJson = [];
    for (int i = 0; i < carts.length; i++) {
      itemsListJson.add({
        "productId": carts[i].itemID,
        "quantity": carts[i].quantity,
        "amount": carts[i].unitPrice * carts[i].quantity,
        "DiscountName": carts[i].discountName,
        "DiscountType": carts[i].discountType,
        "DiscountValue": carts[i].discountValue,
        "MinimumQuantity": carts[i].minimumQuantity,
      });
    }

    //String now = '${DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now())}Z';
    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map map = {
      "deliveryDate": now,
      "depoId": userData.depoId,
      "employeeID": userData.employeeId,
      "TerritoryId": userData.territoryId,
      "chemistId": selectedChemist.itemID,
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
      var resp = json.decode(response.body);
      OrderSendResponse orderSendResponse = OrderSendResponse.fromJson(resp);
      callBack.call(true, orderSendResponse);
      print('Order Submit Response: ${response.body.toString()}');
      print('message: ${orderSendResponse.message}');
    } else {
      var resp = json.decode(response.body);
      OrderSendResponse orderSendResponse = OrderSendResponse.fromJson(resp);
      callBack.call(false, orderSendResponse);
    }
  }

  submitOrderFromArchive(OrderCreate orderCreate, Function(bool isSuccess, OrderSendResponse response) callBack) async {
    List<Map> itemsListJson = [];
    for (int i = 0; i < orderCreate.products.length; i++) {
      itemsListJson.add({
        "productId": orderCreate.products[i].id,
        "quantity": orderCreate.products[i].productQuantity,
        "amount": orderCreate.products[i].tp,
        "DiscountName": orderCreate.products[i].discountName,
        "DiscountType": orderCreate.products[i].discountType,
        "DiscountValue": orderCreate.products[i].discountValue,
        "MinimumQuantity": orderCreate.products[i].minimumQuantity,
      });
    }

    //String now = '${DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now())}Z';
    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map map = {
      "deliveryDate": now,
      "depoId": userData.depoId,
      "employeeID": userData.employeeId,
      "TerritoryId": userData.territoryId,
      "chemistId": orderCreate.chemistId,
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
      var resp = json.decode(response.body);
      print("Success Response : ${resp}");
      OrderSendResponse orderSendResponse = OrderSendResponse.fromJson(resp);
      callBack.call(true, orderSendResponse);
    } else {
      var resp = json.decode(response.body);
      print("Error Response : ${resp}");
      OrderSendResponse orderSendResponse = OrderSendResponse.fromJson(resp);
      callBack.call(false, orderSendResponse);
    }
  }
}
