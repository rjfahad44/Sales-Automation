import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Models/Cart.dart';
import '../Models/Item.dart';
import '../global.dart';

class OrderAPI {
  Future<List<Item>> getItems() async {
    final response = await http.get(
      Uri.parse('${serverPath}/api/Products/Dropdowns'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );


    print("--------------------------");
    print(response.body);
    print(response.statusCode);
    List<Item> items = [];

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);

      for (int i = 0; i < resp["data"].length; i++) {
        items.add(new Item(resp["data"][i]["id"], resp["data"][i]["text"],
            TextEditingController()));
      }

      return items;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Future<List<Item>> getChemis() async {
  //   final response = await http.get(
  //     Uri.parse('${serverPath}/api/Chemists/Dropdowns'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   List<Item> items = [];
  //
  //   if (response.statusCode == 200) {
  //     Map resp = json.decode(response.body);
  //
  //     for (int i = 0; i < resp["data"].length; i++) {
  //       items.add(
  //         new Item(resp["data"][i]["id"], resp["data"][i]["text"],
  //             TextEditingController()),
  //       );
  //     }
  //     return items;
  //   } else {
  //     throw Exception('Failed to load posts');
  //   }
  // }

  Future<List<Item>> getChemis() async {
    final response = await http.get(
      Uri.parse('${serverPath}/api/Chemists/ChemistListForDropdowns?id=${currentLoginUser.userID}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    List<Item> items = [];

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);

      print(resp);

      for (int i = 0; i < resp["data"].length; i++) {
        items.add(
          new Item(resp["data"][i]["id"], resp["data"][i]["text"],
              TextEditingController()),
        );
      }
      print(items.length);
      return items;
    } else {
      throw Exception('Failed to load posts');
    }
  }




  Future<double> getItemPrice(int itemID) async {
    final response = await http.get(
      Uri.parse(
          '${serverPath}/api/Products/ById?id=$itemID'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    List<Item> items = [];

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      if (resp["data"]["price"].runtimeType == double) {
        return resp["data"]["price"];
      } else {
        return 10000000.0;
      }
    } else {
      return 10000000.0;
    }
  }


  Future<bool> submitOrder(List<Cart> carts) async {

    List<Map> itemsListJson = [];
    for(int i = 0; i<carts.length; i++){
      itemsListJson.add({
        "id": 0,
        "orderId": 0,
        "productId": carts[i].itemID,
        "quantity": carts[i].quantity,
        "amount": (carts[i].quantity*carts[i].unitPrice)
      });
    }

    Map map =  {
      "orderDate": "2024-01-27",
      "orderNo": "123654",
      "chemistId": carts[0].chemistID,
      "orderDetails": itemsListJson
    };




    final response = await http.post(
      Uri.parse(
          '${serverPath}/api/Order'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(map),
    );

    if (response.statusCode == 200) {
      Map resp = json.decode(response.body);
      return resp["success"];

    } else {
      return false;

    }
  }



}
