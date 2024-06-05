import 'package:flutter/material.dart';
import 'package:sales_automation/Screens/Attendance/AttendanceScreen.dart';
import 'package:sales_automation/Screens/ImageArchive/ImageArchive.dart';
import 'package:sales_automation/Screens/ImageCaptureScreen/ImageCapture.dart';
import 'package:sales_automation/Screens/AuthentationScreen/LoginScreen.dart';
import 'package:sales_automation/Screens/Order/Models/OrderCreate.dart';
import 'package:sales_automation/Screens/OrderArchiveScreen/OrderArchiveScreen.dart';
import 'package:sales_automation/Screens/OrderDraftScreen/OrderDraftScreen.dart';

import '../../Components/Components.dart';
import '../../Components/MenuButton.dart';
import '../../LocalDB/PrefsDb.dart';
import '../../Services/LocationService.dart';
import '../../global.dart';
import '../ChemistListScreen/ChemistListScreen.dart';
import '../DoctorListScreen/DoctorListScreen.dart';
import '../Order/OrderCreateScreen.dart';
import '../ProductListScreen/ProductListScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationService locationServices = LocationService();
  var prefs = PrefsDb();

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MyTextView("Sales Automation", 16, FontWeight.bold,
              Colors.black, TextAlign.center),
          backgroundColor: themeColor,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Log Out",
                        ),
                        content:
                            const Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () {
                              prefs.saveDataToSP(PrefsDb.USER_DATA, '');
                              prefs.saveDataToSP(PrefsDb.USER_NAME_AND_PASS, '');
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogInScreen()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: const Menu(),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    setState(() async {
      locationInf = await locationServices.getCurrentLocation();
      print("Current Location is  lat: ${locationInf.lat}, lon: ${locationInf.lon}");
      print("Current Location Name: ${locationInf.locationName}");
      print("Current Location Details: ${locationInf.locationDetails}");
      print("Current Location Error: ${locationInf.error}");
    });
  }
}

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double textWidth = 14;
    int gridRow = 3;
    print(screenwidth);
    if (screenwidth > 500) {
      textWidth = 16;
      gridRow = 4;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome: ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "${userData.id}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),

            Card(
              color: primaryButtonColor,
              elevation: 2.0,
              semanticContainer: true,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 0.0, right: 8.0, bottom: 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              'https://media.istockphoto.com/id/2098359215/photo/digital-marketing-concept-businessman-using-laptop-with-ads-dashboard-digital-marketing.jpg?s=1024x1024&w=is&k=20&c=q6RTyRcP6Lli25bBXmKz3F3sIAVSu5PthcuOiAniHzE=',
                              width: 100,
                              height: 100,
                              scale: 1.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            userData.userName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Name: ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              userData.userName,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              'Designation: ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              'TR Code: ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              'Mobile: ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              'Version: ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '1.0',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            GridView.count(
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.vertical,
              crossAxisCount: gridRow,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        orderCreate = OrderCreate();
                        goToPage(const OrderCreateScreen(), true, context);
                      },
                      child: MenuButton(90, "assets/images/newOrder.png",
                          "New Order", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        goToPage(const OrderDraftScreen(), true, context);
                      },
                      child: MenuButton(90, "assets/images/draft.png",
                          "Order Draft", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        goToPage(const OrderArchiveScreen(), true, context);
                      },
                      child: MenuButton(90, "assets/images/archive.png",
                          "Order Archive", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        // goToPage(OrderCreateScreen(), context);
                      },
                      child: MenuButton(90, "assets/images/sync.png",
                          "Syncronize", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        //goToPage(OrderCreateScreen(), context);
                        goToPage(const ImageCapture(), true, context);
                      },
                      child: MenuButton(90, "assets/images/camera.png",
                          "Image Capture", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        goToPage(const ImageArchive(), true, context);
                      },
                      child: MenuButton(90, "assets/images/archive.png",
                          "Image Archive", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        // goToPage(OrderCreateScreen(), context);
                      },
                      child: MenuButton(
                          90, "assets/images/message.png", "Inbox", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        goToPage(const DoctorListScreen(), true, context);
                      },
                      child: MenuButton(
                          90, "assets/images/doctor.png", "Doctor", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        goToPage(const ChemistListScreen(), true, context);
                      },
                      child: MenuButton(90, "assets/images/chemist.png",
                          "Chemist", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        goToPage(const ProductListScreen(), true, context);
                      },
                      child: MenuButton(90, "assets/images/products.png",
                          "Product", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => primaryButtonColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        // goToPage(OrderCreateScreen(), context);
                      },
                      child: MenuButton(90, "assets/images/archive.png",
                          "Archiver Guide", textWidth)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => primaryButtonColor),
                        shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                    onPressed: () {
                      goToPage(const AttendanceScreen(), true, context);
                    },
                    child: MenuButton(90, "assets/images/geoPoint.png",
                        "Geo\nAttendance", textWidth),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
