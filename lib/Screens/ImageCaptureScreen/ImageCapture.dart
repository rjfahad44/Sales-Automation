import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../APIs/ImageUploadApis.dart';
import '../../Components/Components.dart';
import '../../Components/CustomBottomSheetsDialog.dart';
import '../../Components/TransparentProgressDialog.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../global.dart';
import 'dart:core';

import 'Model/ImageDataModel.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  ImageUploadApis imageUploadApis = ImageUploadApis();
  File? _image;
  bool _isImageChoose = false;
  bool _isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  final imageHiveBox = HiveBoxHelper<ImageDataModel>('image_db');
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

  saveImage(ImageDataModel data, File image,
      Function(bool isSuccess) callback) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(image.readAsBytesSync());
    data.imagePath = filePath;
    imageHiveBox.add(data).then((value) {
      callback.call(true);
    });
  }

  // sendPrescribedProducts(
  //     File image,
  //     String doctorName,
  //     int employeeId,
  //     List<Map<String, dynamic>> prescribedProducts,
  //     Function(bool isSuccess) callback) async {
  //   var uri = Uri.parse('${serverPath}/api/ImageCapture/SubmitImageCapture');
  //   var request = http.Request('POST', uri);
  //   var authorizationToken = currentLoginUser.token;
  //   print('\n\nToken : $authorizationToken');
  //   request.headers['accept'] = '*/*';
  //   request.headers['Authorization'] = 'Bearer $authorizationToken';
  //   request.headers['Content-Type'] = 'application/json';
  //
  //   final bytes = await image.readAsBytes();
  //   var base64Image = base64Encode(bytes);
  //
  //   print('\n\nBase64Image Data => $base64Image');
  //   print('\n\nprescribedProducts => $prescribedProducts');
  //   final data = {
  //     'doctorName': doctorName,
  //     'employeeId': employeeId,
  //     'base64Image': base64Image,
  //     // 'prescribedProducts': prescribedProducts.toString(),
  //   };
  //
  //   var jsonData = jsonEncode(data);
  //   request.body = jsonData;
  //
  //   print('\n\nRequest headers: ${request.headers}');
  //   print('\n\nSet Request body data : ${jsonData}');
  //   print('\n\nRequest body : ${request.body}');
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     callback.call(true);
  //     Fluttertoast.showToast(
  //         msg: "Successfully upload!",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     print('sent successfully!');
  //   } else {
  //     callback.call(false);
  //     Fluttertoast.showToast(
  //         msg: "Error: ${response.reasonPhrase}",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     print('Error sending data: ${response.reasonPhrase}');
  //   }
  // }

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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(2.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
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
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]),
                      onPressed: () => {
                        _imageFromCamera(),
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 50.0,
                  ),
                  SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(2.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
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
                                fontWeight: FontWeight.bold,
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
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                    _isImageChoose = false;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image(
                                  image: FileImage(
                                    _isImageChoose
                                        ? _image ?? File('')
                                        : File(''),
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
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
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10.0, right: 5.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => states.isEmpty
                                      ? primaryButtonColor
                                      : Colors.black26),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          onPressed: () async {
                            var doctorName = _doctorNameController.text.toString();
                            var employeeId = userData.employeeId;
                            if (doctorName.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Doctor Name",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (_image == null) {
                              Fluttertoast.showToast(
                                  msg: "Image is empty!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              enableUploadButtons.value = !enableUploadButtons.value;
                              showTransparentProgressDialog(context);
                              await imageUploadApis.sendPrescribedProducts(_image!, doctorName,
                                  employeeId, prescribedProducts, (isSuccess, response) {
                                    hideTransparentProgressDialog(context);
                                if (isSuccess) {
                                  setState(() {
                                    _doctorNameController.text = "";
                                    _image = null;
                                    _isImageChoose = false;
                                    _isLoading = false;
                                  });


                                  showBottomSheetDialog(context, response);

                                  // Fluttertoast.showToast(
                                  //     msg: "Successfully upload!",
                                  //     toastLength: Toast.LENGTH_LONG,
                                  //     gravity: ToastGravity.BOTTOM,
                                  //     timeInSecForIosWeb: 1,
                                  //     backgroundColor: Colors.red,
                                  //     textColor: Colors.white,
                                  //     fontSize: 16.0);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: response.message ?? "Error!!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              });
                              enableUploadButtons.value =
                                  !enableUploadButtons.value;
                            }
                          },
                          child: (enableUploadButtons.value)
                              ? const Text(
                                  'Upload',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : const Text(
                                  'Uploading...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, left: 5.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => states.isEmpty
                                      ? primaryButtonColor
                                      : Colors.black26),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          onPressed: () async {
                            var doctorName =
                                _doctorNameController.text.toString();
                            var employeeId = userData.employeeId;
                            if (doctorName.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Doctor Name",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (_image == null) {
                              Fluttertoast.showToast(
                                  msg: "Image is empty!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              enableUploadButtons.value =
                                  !enableUploadButtons.value;
                              var data = ImageDataModel(
                                  imagePath: "",
                                  doctorName: doctorName,
                                  employeeId: employeeId);
                              saveImage(data, _image!, (isDataAdd) {
                                setState(() {
                                  _doctorNameController.text = "";
                                  _image = null;
                                  _isImageChoose = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Save data.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              });

                              enableUploadButtons.value =
                                  !enableUploadButtons.value;
                            }
                          },
                          child: (enableUploadButtons.value)
                              ? const Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : const Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
