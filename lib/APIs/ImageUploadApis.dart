import 'dart:convert';
import 'dart:io';
import '../Screens/ImageCaptureScreen/Model/ImageDataModel.dart';
import '../Screens/ImageCaptureScreen/Model/ImageUploadResponse.dart';
import '../Screens/ProductListScreen/Model/Product.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ImageUploadApis {
  sendPrescribedProducts(
      File image,
      String doctorAddress,
      int doctorId,
      List<Map<String, dynamic>> prescribedProducts,
      Function(bool isSuccess, ImageUploadResponse respons) callback) async {
    final bytes = await image.readAsBytes();
    var base64Image = base64Encode(bytes);

    final data = {
      'imageName': p.basename(image.path),
      'doctorId': doctorId,
      'address': doctorAddress,
      'employeeId': userData.data.employeeId,
      'longitude': locationInf.lat,
      'latitude': locationInf.lon,
      'base64Image': base64Image,
      'prescribedProducts': prescribedProducts,
    };

    final response = await http.post(
      Uri.parse('$serverPath/api/ImageCapture/SubmitImageCapture'),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.data.token}",
      },
      body: jsonEncode(data),
    );

    String encodedData = jsonEncode(data);
    print('Image Upload Request Body : $encodedData');

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      ImageUploadResponse res =
          ImageUploadResponse.fromJson(json as Map<String, dynamic>);
      callback.call(true, res);
      print('sent successfully!');
      print('Image Upload Response: ${response.body.toString()}');
    } else {
      var json = jsonDecode(response.body);
      //print('Error body : $json');
      ImageUploadResponse res =
          ImageUploadResponse.fromJson(json as Map<String, dynamic>);
      callback.call(false, res);
      print('Error sending data: ${response.reasonPhrase}');
    }
  }

  sendAllPrescribedProducts(
      Future<List<ImageDataModel>>? imageDataList,
      imageHiveBox,
      Function(Future<List<ImageDataModel>>? imageDataList) callback,
      Function(bool isSuccess) successCallBack) async {
    imageDataList?.then((value) async {
      int count = 0;
      int pos = 0;
      for (var p in value) {
        var bytes = await File(p.imagePath).readAsBytes();
        var base64Image = base64Encode(bytes);
        var data = {
          'imageName': p.doctorName,
          'doctorId': 0,
          'address': "",
          'employeeId': userData.data.employeeId,
          'longitude': locationInf.lat,
          'latitude': locationInf.lon,
          'base64Image': base64Image,
          // 'prescribedProducts':prescribedProducts,
        };

        final response = await http.post(
          Uri.parse('$serverPath/api/ImageCapture/SubmitImageCapture'),
          headers: {
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer ${userData.data.token}",
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          imageHiveBox.delete(pos);
          imageDataList = imageHiveBox.getAll();
          callback.call(imageDataList);
          pos--;
          count++;
          print('upload pending: $count');
        } else {
          print('error $count');
        }
        pos++;
      }

      print('count : $count');
      print('list size : ${value.length}');

      if (count == value.length) {
        successCallBack.call(true);
      } else {
        successCallBack.call(false);
      }
    });
  }
}
