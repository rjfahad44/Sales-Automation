import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_automation/APIs/ImageUploadApis.dart';
import '../../Components/Components.dart';
import '../../Components/ImageUploadResponseCustomDialog.dart';
import '../../Components/TransparentProgressDialog.dart';
import '../../LocalDB/DatabaseHelper.dart';
import '../../global.dart';
import '../ImageCaptureScreen/Model/ImageDataModel.dart';

class ImageDraft extends StatefulWidget {
  const ImageDraft({super.key});

  @override
  State<StatefulWidget> createState() => _ImageArchiveState();
}

class _ImageArchiveState extends State<ImageDraft> {
  ImageUploadApis imageUploadApis = ImageUploadApis();
  Future<List<ImageDataModel>>? imageDataList;
  bool isImageDataListIsNotEmpty = true;
  File? _image;
  final imageHiveBox = HiveBoxHelper<ImageDataModel>('image_db');
  final ValueNotifier<bool> enableUploadButtons = ValueNotifier(true);
  List<Map<String, dynamic>> prescribedProducts = [
    {'productName': 'Product A', 'quantity': 1},
    {'productName': 'Product B', 'quantity': 2},
  ];

  @override
  void initState() {
    setState(() {
      imageDataList = imageHiveBox.getAll();
      imageDataList?.then((value) {
        setState(() {
          isImageDataListIsNotEmpty = value.isNotEmpty;
        });
        print("initState imageDataList : $value");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Image Draft", 16, FontWeight.bold, Colors.black,
              TextAlign.center),
          backgroundColor: themeColor,
        ),
        body: isImageDataListIsNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          FutureBuilder<List<ImageDataModel>>(
                            future: imageDataList,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final dataList = snapshot.data!;
                                return ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: dataList.length,
                                  itemBuilder: (context, index) {
                                    final data = dataList[index];
                                    return Card(
                                      elevation: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(data.imagePath),
                                                    fit: BoxFit.cover,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Dr. Name : ${data.doctorName}",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  imageHiveBox.delete(index);
                                                  setState(() {
                                                    imageDataList =
                                                        imageHiveBox.getAll();
                                                    imageDataList
                                                        ?.then((value) {
                                                      setState(() {
                                                        isImageDataListIsNotEmpty =
                                                            value.isNotEmpty;
                                                      });
                                                    });
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.send,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  showTransparentProgressDialog(context);
                                                  imageUploadApis
                                                      .sendPrescribedProducts(
                                                          File(data.imagePath),
                                                          data.doctorName,
                                                          data.employeeId,
                                                          prescribedProducts,
                                                          (isSuccess, response) {
                                                            hideTransparentProgressDialog(context);
                                                    if (isSuccess) {
                                                      imageHiveBox
                                                          .delete(index);
                                                      setState(() {
                                                        imageDataList =
                                                            imageHiveBox
                                                                .getAll();
                                                        imageDataList
                                                            ?.then((value) {
                                                          setState(() {
                                                            isImageDataListIsNotEmpty =
                                                                value
                                                                    .isNotEmpty;
                                                          });
                                                        });
                                                      });

                                                      showBottomSheetDialog(context, response);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: response.message ?? "Error!!",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateColor.resolveWith(
                                            (states) => states.isEmpty
                                                ? primaryButtonColor
                                                : Colors.black26),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                                onPressed: () async {
                                  showTransparentProgressDialog(context);
                                  enableUploadButtons.value =
                                      !enableUploadButtons.value;
                                  await imageUploadApis
                                      .sendAllPrescribedProducts(
                                          imageDataList, imageHiveBox,
                                          (Future<List<ImageDataModel>>?
                                              dataList) {
                                    setState(() {
                                      imageDataList = dataList;
                                      imageDataList?.then((value) {
                                        isImageDataListIsNotEmpty =
                                            value.isNotEmpty;
                                      });
                                    });
                                  }, (isSuccess) {
                                    hideTransparentProgressDialog(context);
                                    if (isSuccess) {
                                      Fluttertoast.showToast(
                                          msg: "Successfully Upload All Data",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Error!!",
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
                                },
                                child: (enableUploadButtons.value)
                                    ? const Text(
                                        'Upload All',
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
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: MyTextView("No Data Found!", 18, FontWeight.bold,
                    Colors.black, TextAlign.center),
              ),
      ),
    );
  }
}
