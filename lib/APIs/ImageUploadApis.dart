import 'dart:convert';
import 'dart:io';
import '../Screens/ImageCaptureScreen/Model/ImageDataModel.dart';
import '../global.dart';
import 'package:http/http.dart' as http;

class ImageUploadApis {
  sendPrescribedProducts(
      File image,
      String doctorName,
      int employeeId,
      List<Map<String, dynamic>> prescribedProducts,
      Function(bool isSuccess) callback) async {

    final bytes = await image.readAsBytes();
    var base64Image = base64Encode(bytes);

    final data = {
      'doctorName': doctorName,
      'employeeId': employeeId,
      'base64Image': base64Image,
      // 'prescribedProducts': prescribedProducts.toString(),
    };

    final response = await http.post(
      Uri.parse('$serverPath/api/ImageCapture/SubmitImageCapture'),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userData.token}",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      callback.call(true);
      print('sent successfully!');
    } else {
      callback.call(false);
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
          'doctorName': p.doctorName,
          'employeeId': p.employeeId,
          'base64Image': base64Image,
          // 'prescribedProducts': prescribedProducts.toString(),
        };

        final response = await http.post(
          Uri.parse('$serverPath/api/ImageCapture/SubmitImageCapture'),
          headers: {
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer ${userData.token}",
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
