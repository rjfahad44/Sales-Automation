import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:sales_automation/APIs/AttendanceAPI.dart';
import 'package:sales_automation/Models/LocationInfo.dart';
import 'package:sales_automation/Services/LocationServices.dart';

import '../../Components/Components.dart';
import '../../global.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ValueNotifier<bool> enableButton = ValueNotifier(true);
  LocationServices locationServices = LocationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyTextView("Geo Attendance", 16, FontWeight.bold, Colors.black,
            TextAlign.center),
        backgroundColor: themeColor,
      ),
      body: FutureBuilder<LocationInf>(
        future: locationServices.getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Tracking location...'));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 500,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCameraFit: CameraFit.bounds(
                          bounds: LatLngBounds(
                              LatLng(
                                  snapshot.data!.marker.point.latitude - 0.002,
                                  snapshot.data!.marker.point.longitude -
                                      0.002),
                              LatLng(
                                  snapshot.data!.marker.point.latitude + 0.002,
                                  snapshot.data!.marker.point.longitude +
                                      0.002)),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      children: [
                        openStreetMapTileLayer,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<bool>(
                        valueListenable: enableButton,
                        builder: (context, val, child) {
                          return ElevatedButton(
                            onPressed: (val)
                                ? () async {
                                    enableButton.value = !enableButton.value;
                                    AttendanceAPI api = AttendanceAPI();
                                    String status = await api
                                        .submitAttendance(snapshot.data!);
                                    Fluttertoast.showToast(
                                        msg: status,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    enableButton.value = !enableButton.value;
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: (val)
                                ? const Text(
                                    'Submit attendance ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'Loading ... ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Future<void> loadData() async {
  //   // LocationServices locationServices = LocationServices();
  //   // LocationInf locationInf = await locationServices.getCurrentLocation();
  //   //
  //   // currentLocationMarker = Marker(
  //   //   point: LatLng(locationInf.lat, locationInf.lon),
  //   //   height: 12,
  //   //   width: 12,
  //   //   child: ColoredBox(color: Colors.blue[900]!),
  //   // );
  //
  //   // print("-------------------");
  //   // print(locationInf.lat);
  //   // print(locationInf.lon);
  //   //
  //   // setState(() {});
  //
  //   // Fluttertoast.showToast(
  //   //     msg: "Lat: ${locationInf.lat}, Lon: ${locationInf.lon}, Msg: ${locationInf.locationDetails} ",
  //   //     toastLength: Toast.LENGTH_LONG,
  //   //     gravity: ToastGravity.BOTTOM,
  //   //     backgroundColor: themeColor,
  //   //     textColor: primaryTextColor,
  //   //     fontSize: 16.0);
  // }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        tileProvider: CancellableNetworkTileProvider(),
      );
}
