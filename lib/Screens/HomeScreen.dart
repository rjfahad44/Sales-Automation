import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:sales_automation/Screens/Attendance/AttendanceScreen.dart';
import 'package:sales_automation/Screens/ImageArchive/ImageArchive.dart';
import 'package:sales_automation/Screens/ImageCaptureScreen/ImageCapture.dart';

import '../Components/Components.dart';
import '../Components/MenuButton.dart';
import '../Services/LocationServices.dart';
import '../global.dart';
import 'Order/OrderCreateScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: MyTextView("Sales Automation", 16, FontWeight.bold,
                  Colors.black, TextAlign.center),
              backgroundColor: themeColor,
            ),
            body: Menu()));
  }

  Future<void> loadData() async {
    LocationServices locationServices = LocationServices();

    // await locationServices.enableLocation();
    // cLocationInf = await locationServices.getCurrentLocation();
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
      child: GridView.count(
        crossAxisCount: gridRow,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  goToPage(OrderCreateScreen(), context);
                },
                child: MenuButton(
                    90, "assets/images/newOrder.png", "New Order", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  // goToPage(OrderCreateScreen(), context);
                },
                child: MenuButton(
                    90, "assets/images/draft.png", "Order Draft", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  // goToPage(OrderCreateScreen(), context);
                },
                child: MenuButton(90, "assets/images/archive.png",
                    "Order Archive", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  // goToPage(OrderCreateScreen(), context);
                },
                child: MenuButton(
                    90, "assets/images/sync.png", "Syncronize", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  //goToPage(OrderCreateScreen(), context);
                  goToPage(const ImageCapture(), context);
                },
                child: MenuButton(90, "assets/images/camera.png",
                    "Image Capture", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  goToPage(const ImageArchive(), context);
                },
                child: MenuButton(90, "assets/images/archive.png",
                    "Image Archive", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  // goToPage(OrderCreateScreen(), context);
                },
                child: MenuButton(
                    90, "assets/images/doctor.png", "Doctor", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  // goToPage(OrderCreateScreen(), context);
                },
                child: MenuButton(
                    90, "assets/images/chemist.png", "Chemist", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {
                  // goToPage(OrderCreateScreen(), context);
                },
                child: MenuButton(
                    90, "assets/images/products.png", "Product", textWidth)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryButtonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => primaryButtonColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              onPressed: () {
                goToPage(AttendanceScreen(), context);
              },
              child: MenuButton(90, "assets/images/geoPoint.png",
                  "Geo\nAttendance", textWidth),
            ),
          ),
        ],
      ),
    );
  }

  void goToPage(Widget page, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
