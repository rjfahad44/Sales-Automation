import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../APIs/ImageUploadApis.dart';
import '../../APIs/OrderAPI.dart';
import '../../Components/Components.dart';
import '../../Components/ImageUploadResponseCustomDialog.dart';
import '../../Components/TransparentProgressDialog.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../Models/Doctor.dart';
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
  OrderAPI api = OrderAPI();
  ImageUploadApis imageUploadApis = ImageUploadApis();
  File? _image;
  bool _isImageChoose = false;
  List<Doctor> doctorList = [];
  Doctor? selectedDoctor;
  bool _isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  final imageHiveBox = HiveBoxHelper<ImageDataModel>('image_db');
  final ValueNotifier<bool> enableUploadButtons = ValueNotifier(true);
  List<Map<String, dynamic>> prescribedProducts = [
    {'productId': '1', 'productName': 'Product A', 'quantity': 1},
    {'productId': '2', 'productName': 'Product A', 'quantity': 1},
  ];

  @override
  void initState() {
    api.getDoctorList().then((value) {
      setState(() {
        doctorList = value;
        _isLoading = true;
      });
    });
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Image capture view
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
                    onPressed: _imageFromCamera,
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
                  ),
                ),
                const SizedBox(
                  width: 35.0,
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
                    onPressed: _imageFromGallery,
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
                  ),
                ),
              ]),
              const SizedBox(
                height: 10.0,
              ),
              // Image Preview view
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: _isImageChoose,
                    child: Stack(
                      children: [
                        // Image view
                        SizedBox(
                          width: 160.0,
                          height: 170.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              image: FileImage(_isImageChoose
                                  ? _image ?? File('')
                                  : File('')),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 0,
                          right: 0,
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              // Select Doctor view
              Card(
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  child: _isLoading
                      ? DropdownButton<Doctor>(
                          hint: MyTextView(
                            selectedDoctor?.doctorName ??
                                "Please select doctor",
                            12,
                            FontWeight.normal,
                            Colors.black,
                            TextAlign.start,
                          ),
                          value: selectedDoctor,
                          isExpanded: true,
                          // Ensures the dropdown takes the full width of its parent
                          underline: Container(),
                          // Removes the default underline
                          onChanged: (Doctor? selectedValue) {
                            if (selectedValue?.doctorName.isEmpty == true) {
                              selectedValue?.doctorName =
                                  "No Name Found! id:${selectedValue.id}";
                            }
                            setState(() {
                              selectedDoctor = selectedValue;
                            });
                          },
                          items: doctorList.map((Doctor item) {
                            if (item.doctorName.isEmpty) {
                              item.doctorName = "No Name Found! id:${item.id}";
                            }
                            return DropdownMenuItem<Doctor>(
                              value: item,
                              child: MyTextView(
                                item.doctorName,
                                12,
                                FontWeight.bold,
                                Colors.black,
                                TextAlign.start,
                              ),
                            );
                          }).toList(),
                        )
                      : const Center(
                          child: SizedBox(
                            height: 40,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                ),
              ),
              // Add Product view
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    minimumSize: const Size(0, 50),
                    backgroundColor: Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextView(
                        "Add Product",
                        14,
                        FontWeight.bold,
                        Colors.black,
                        TextAlign.left,
                      ),
                      // Add icon on the right
                      const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),
              // Button view
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith(
                                (states) => states.isEmpty
                                    ? primaryButtonColor
                                    : Colors.black26),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () async {
                          if (_image == null) {
                            Fluttertoast.showToast(
                                msg: "Image is empty!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.orange,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            enableUploadButtons.value =
                                !enableUploadButtons.value;
                            showTransparentProgressDialog(context);
                            await imageUploadApis.sendPrescribedProducts(
                                _image!,
                                "",
                                selectedDoctor?.id ?? 0,
                                prescribedProducts, (isSuccess, response) {
                              hideTransparentProgressDialog(context);
                              if (isSuccess) {
                                setState(() {
                                  _image = null;
                                  selectedDoctor = null;
                                  _isImageChoose = false;
                                  _isLoading = false;
                                });

                                showBottomSheetDialog(context, response);
                              } else {
                                Fluttertoast.showToast(
                                    msg: response.message ?? "Error!!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.orange,
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
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith(
                                (states) => states.isEmpty
                                    ? primaryButtonColor
                                    : Colors.black26),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () async {
                          if (_image == null) {
                            Fluttertoast.showToast(
                                msg: "Image is empty!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.orange,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            enableUploadButtons.value =
                                !enableUploadButtons.value;
                            var data = ImageDataModel(
                                imagePath: "",
                                doctorName: selectedDoctor?.doctorName ?? '',
                                doctorId: selectedDoctor?.id ?? 0);
                            saveImage(data, _image!, (isDataAdd) {
                              setState(() {
                                _image = null;
                                selectedDoctor = null;
                                _isImageChoose = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "Save data.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.orange,
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
    );
  }
}
