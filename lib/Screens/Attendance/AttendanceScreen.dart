
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:sales_automation/APIs/AttendanceAPI.dart';
import 'package:sales_automation/Models/LocationInfo.dart';
import 'package:sales_automation/Services/LocationService.dart';
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
  LocationService locationServices = LocationService();
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
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
            return  Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCameraFit: CameraFit.bounds(
                      bounds: LatLngBounds(
                        LatLng(
                          snapshot.data!.marker.point.latitude - 0.002,
                          snapshot.data!.marker.point.longitude - 0.002,
                        ),
                        LatLng(
                          snapshot.data!.marker.point.latitude + 0.002,
                          snapshot.data!.marker.point.longitude + 0.002,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                    //onTap: _onMapTapped,
                  ),
                  children: [
                    openStreetMapTileLayer,
                  ],
                ),
                Positioned(
                  bottom: 16.0, // Adjust this value as needed to control the distance from the bottom
                  left: 16.0, // Adjust for padding on the left
                  right: 16.0, // Adjust for padding on the right
                  child: ValueListenableBuilder<bool>(
                    valueListenable: enableButton,
                    builder: (context, val, child) {
                      return ElevatedButton(
                        onPressed: (val)
                            ? () async {
                          enableButton.value = !enableButton.value;
                          AttendanceAPI api = AttendanceAPI();
                          String status = await api.submitAttendance(snapshot.data!);
                          Fluttertoast.showToast(
                            msg: status,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          enableButton.value = !enableButton.value;
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                    },
                  ),
                ),
              ],
            );

          }
        },
      ),
    );
  }

  void _onMapTapped(TapPosition tapPosition, LatLng tappedPosition) {
    setState(() {
      selectedLocation = tappedPosition;
    });
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        tileProvider: CancellableNetworkTileProvider(),
      );
}
