import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Components/Components.dart';
import '../../global.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  late File _image;
  bool _isImageChoose = false;
  ImagePicker imagePicker = ImagePicker();
  final TextEditingController _doctorNameController = TextEditingController();
  final ValueNotifier<bool> enableUploadButtons = ValueNotifier(true);
  List<Map<String, dynamic>> prescribedProducts = [
    {'productName': 'Product A', 'quantity': 1},
    {'productName': 'Product B', 'quantity': 2},
  ];

  _imageFromCamera() async {
    try {
      var capturedImage =
          await imagePicker.pickImage(source: ImageSource.camera);
      final File imagePath = File(capturedImage?.path ?? '');
      if (capturedImage == null) {
        _isImageChoose = false;
        const SnackBar(
          content: Text('No file was selected'),
          backgroundColor: Colors.red,
        );
      } else {
        setState(() {
          _isImageChoose = true;
          _image = imagePath;
        });
      }
    } catch (e) {
      SnackBar(
        content: Text('$e'),
        backgroundColor: Colors.red,
      );
    }
  }

  _imageFromGallery() async {
    var uploadedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    final File imagePath = File(uploadedImage?.path ?? '');

    if (uploadedImage == null) {
      _isImageChoose = false;
      const SnackBar(
        content: Text('No file selected'),
        backgroundColor: Colors.red,
      );
    } else {
      setState(() {
        _isImageChoose = true;
        _image = imagePath;
      });
    }
  }

  sendPrescribedProducts(String doctorName, int employeeId, List<Map<String, dynamic>> prescribedProducts) async {
    var uri = Uri.parse('${serverPath}/api/ImageCapture/SubmitImageCapture');
    var request = http.Request('POST', uri);
    var authorizationToken = currentLoginUser.token;
    print('\n\nToken : $authorizationToken');
    request.headers['accept'] = '*/*';
    request.headers['Authorization'] = 'Bearer $authorizationToken';
    request.headers['Content-Type'] = 'application/json';

    final bytes = await _image.readAsBytes();
    var base64Image = base64Encode(bytes);

    print('\n\nBase64Image Data => $base64Image');
    print('\n\nprescribedProducts => $prescribedProducts');
    final data = {
      'doctorName': doctorName,
      'employeeId': employeeId,
      'base64Image': base64Image,
      // 'prescribedProducts': prescribedProducts.toString(),
    };

    var jsonData = jsonEncode(data);
    request.body = jsonData;

    print('\n\nRequest headers: ${request.headers}');
    print('\n\nSet Request body data : ${jsonData}');
    print('\n\nRequest body : ${request.body}');
    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Successfully upload!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('sent successfully!');
    } else {
      Fluttertoast.showToast(
          msg: "Error: ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Error sending data: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Image Capture", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 24.0,
                                    ),
                                  ),
                                  Text(
                                    "Camera",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ]),
                            onPressed: () => {
                              _imageFromCamera(),
                            },
                          ),
                        ),
                        SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Icon(
                                      Icons.photo_library_outlined,
                                      size: 24.0,
                                    ),
                                  ),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ]),
                            onPressed: () => {
                              _imageFromGallery(),
                            },
                          ),
                        ),
                      ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: _isImageChoose,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image(
                                    image: FileImage(
                                        _isImageChoose ? _image : File(''),
                                    ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _doctorNameController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Doctor name is empty!!";
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      label: const Text("Doctor name"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 0.60, color: Color(0xFF6C6A6A)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child:  ValueListenableBuilder<bool>(
                        valueListenable: enableUploadButtons,
                        builder: (context, val, child) {
                          return ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                        (states) => primaryButtonColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                            onPressed: () async {
                              var doctorName =
                              _doctorNameController.text.toString();
                              var employeeId = currentLoginUser.userID;
                              if (doctorName.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Doctor Name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (!_isImageChoose) {
                                Fluttertoast.showToast(
                                    msg: "Image is empty!!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                enableUploadButtons.value = !enableUploadButtons.value;
                                await sendPrescribedProducts(doctorName, employeeId, prescribedProducts);
                                enableUploadButtons.value = !enableUploadButtons.value;
                              }
                            },
                            child: (val)
                                ? const Text(
                              'Upload ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                                : const Text(
                              'Uploading ... ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
