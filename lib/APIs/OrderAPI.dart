import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_automation/Models/Doctor.dart';
import '../LocalDB/DatabaseHelper.dart';
import '../Models/Cart.dart';
import '../Models/ChemistDropdownResponse.dart';
import '../Models/Item.dart';
import '../Models/OrderCreate.dart';
import '../Models/OrderHistoryData.dart';
import '../Models/OrderResponse.dart';
import '../Screens/ProductListScreen/Model/Product.dart';
import '../global.dart';
import 'package:intl/intl.dart';

class OrderAPI {

  Future<List<Product>> getProducts() async {

    final response = await http.get(
      Uri.parse('$serverPath/api/Products'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
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
        "Authorization": "Bearer ${userData.data.token}",
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

  Future<List<ChemistModel>> getChemistListForDropdown() async {
    final response = await http.get(
      Uri.parse('$serverPath/api/Chemists/ChemistListForDropdowns?territoryId=${userData.data.employeeId}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
      },
    );

    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      final items = resp['data'] as List<dynamic>;
      return items.map((jsonItem) => ChemistModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load Chemist List');
    }
  }

  Future<List<Doctor>> getDoctorList() async {
    final response = await http.get(
      Uri.parse('$serverPath/api/Doctor/TerritoryWiseDoctorList?territoryID=${userData.data.employeeId}'),
      headers: {
        "accept": "*/*",
        "Authorization": "Bearer ${userData.data.token}",
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
        "Authorization": "Bearer ${userData.data.token}",
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

  submitOrder(List<Cart> carts, Function(bool isSuccess, OrderResponse response) callBack) async {
    List<Map> itemsListJson = [];
    for (int i = 0; i < carts.length; i++) {
      itemsListJson.add({
        "productId": carts[i].itemID,
        "quantity": carts[i].quantity,
        // "amount": carts[i].unitPrice * carts[i].quantity,
        // "unitPrice": carts[i].unitPrice,
      });
    }

    //String now = '${DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now())}Z';
    String now = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    Map map = {
      "deliveryDate": now,
      "chemistId": selectedChemist.chemistID,
      "depoId": userData.data.depoId,
      "territoryID": userData.data.territoryId,
      "employeeId": userData.data.employeeId,
      "longitude": locationInf.lat.toString(),
      "latitude": locationInf.lon.toString(),
      "orderDetails": itemsListJson
    };

    final response = await http.post(
      Uri.parse('$serverPath/api/Order'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
      },
      body: jsonEncode(map),
    );


    print("-------------------OrderCreate------------------------");
    print("Request Body : ${jsonEncode(map)}");
    print(response.body);

    if (response.statusCode == 200) {
      var resp = json.decode(response.body);
      OrderResponse orderSendResponse = OrderResponse.fromJson(resp);
      callBack.call(true, orderSendResponse);
      print('Order Submit Response: ${response.body.toString()}');
      print('message: ${orderSendResponse.message}');
    } else {
      var resp = json.decode(response.body);
      OrderResponse orderSendResponse = OrderResponse.fromJson(resp);
      callBack.call(false, orderSendResponse);
    }
  }

  submitOrderFromArchive(OrderCreate orderCreate, Function(bool isSuccess, OrderResponse response) callBack) async {
    List<Map> itemsListJson = [];
    for (int i = 0; i < orderCreate.products.length; i++) {
      itemsListJson.add({
        "productId": orderCreate.products[i].productId,
        "quantity": orderCreate.products[i].productQuantity,
        // "amount": carts[i].unitPrice * carts[i].quantity,
        // "unitPrice": carts[i].unitPrice,
      });
    }

    //String now = '${DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now())}Z';
    String now = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    Map map = {
      "deliveryDate": now,
      "chemistId": orderCreate.chemistId,
      "depoId": userData.data.depoId,
      "territoryID": userData.data.territoryId,
      "employeeId": userData.data.employeeId,
      "longitude": locationInf.lat.toString(),
      "latitude": locationInf.lon.toString(),
      "orderDetails": itemsListJson
    };

    final response = await http.post(
      Uri.parse('$serverPath/api/Order'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
      },
      body: jsonEncode(map),
    );


    print("-------------------OrderCreate------------------------");
    print("Request Body : ${jsonEncode(map)}");
    print(response.body);

    if (response.statusCode == 200) {
      var resp = json.decode(response.body);
      OrderResponse orderSendResponse = OrderResponse.fromJson(resp);
      callBack.call(true, orderSendResponse);
      print('Order Submit Response: ${response.body.toString()}');
      print('message: ${orderSendResponse.message}');
    } else {
      var resp = json.decode(response.body);
      OrderResponse orderSendResponse = OrderResponse.fromJson(resp);
      callBack.call(false, orderSendResponse);
    }
  }

  submitOrderListFromArchive(
      List<OrderCreate> orderList,
      HiveBoxHelper<OrderCreate> hiveBox,
      Function(bool isSuccess, int totalOrders, double totalPrice) callBack
      ) async {

    double totalPrice = 0.0;
    int totalOrders;
    bool isSuccess = true;
    totalOrders = orderList.length;

    for (int i =0; i< orderList.length; i++) {
      var order = orderList[i];
      print("order : $order");
      List<Map> itemsListJson = [];
      for (int i = 0; i < order.products.length; i++) {
        itemsListJson.add({
          "productId": order.products[i].productId,
          "quantity": order.products[i].productQuantity,
        });
      }

      String now = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
      Map map = {
        "deliveryDate": now,
        "chemistId": order.chemistId,
        "depoId": userData.data.depoId,
        "territoryID": userData.data.territoryId,
        "employeeId": userData.data.employeeId,
        "longitude": locationInf.lat.toString(),
        "latitude": locationInf.lon.toString(),
        "orderDetails": itemsListJson,
      };

      try {
        final response = await http.post(
          Uri.parse('$serverPath/api/Order'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${userData.data.token}",
          },
          body: jsonEncode(map),
        );

        // print("-------------------OrderCreate------------------------");
        // print("Request Body : ${jsonEncode(map)}");
        // print("Response Body : ${response.body}");

        if (response.statusCode == 200) {
          //var resp = json.decode(response.body);
          //OrderResponse orderResponse = OrderResponse.fromJson(resp);
          hiveBox.deleteItem(order);
          totalPrice += order.finalAmount;
        } else {
          isSuccess = false;
          //var resp = json.decode(response.body);
          //OrderResponse orderResponse = OrderResponse.fromJson(resp);
        }
      } catch (e) {
        isSuccess = false;
        print('catch Error submitting order: $e');
      }
    }

    // Call the callback after processing all orders
    callBack(isSuccess, totalOrders, totalPrice);
  }

  Future<List<OrderHistoryData>?> getOrderHistoryData(DateTime? fromDate, DateTime? toDate) async {
    final String fromDateString = DateFormat("yyyy-MM-dd").format(fromDate ?? DateTime.now());
    final String toDateString = DateFormat("yyyy-MM-dd").format(toDate ?? DateTime.now());
    final String url = '$serverPath/api/Order/OrderListByEmployeeId?employeeId=${userData.data.employeeId}&fromDate=$fromDateString&toDate=$toDateString';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer ${userData.data.token}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Response: ${data}');
        return (data['data'] as List).map((item) => OrderHistoryData.fromJson(item)).toList();
      } else {
        print('Failed to fetch orders. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error occurred: $error');
      return null;
    }
  }

}
