import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:sales_automation/APIs/AttendanceAPI.dart';
import 'package:sales_automation/Models/LocationInfo.dart';
import 'package:sales_automation/Screens/Attendance/AttendanceListScreen.dart';
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
  AttendanceAPI api = AttendanceAPI();
  final ValueNotifier<bool> enableButton = ValueNotifier(true);
  final ValueNotifier<LatLng?> selectedLocation = ValueNotifier<LatLng?>(null);
  LocationInf currentLocation = LocationInf();

  @override
  void initState() {
    setState(() {
      selectedLocation.value = LatLng(locationInf.lat, locationInf.lon);
    });
    super.initState();
  }

  @override
  void dispose() {
    selectedLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Geo Attendance"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: LatLngBounds(
                  LatLng((selectedLocation.value?.latitude ?? 23.7561) - 0.002, (selectedLocation.value?.longitude ?? 90.3872) - 0.002),
                  LatLng((selectedLocation.value?.latitude ?? 23.7561) + 0.002, (selectedLocation.value?.longitude ?? 90.3872) + 0.002),
                ),
                padding: const EdgeInsets.all(8),
              ),
              onTap: _onMapTapped,
            ),
            children: [
              openStreetMapTileLayer,
              ValueListenableBuilder<LatLng?>(
                valueListenable: selectedLocation,
                builder: (context, location, _) {
                  return MarkerLayer(
                    markers: [
                      if (location != null)
                        Marker(
                          point: location,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),

          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ValueListenableBuilder<bool>(
              valueListenable: enableButton,
              builder: (context, val, child) {
                return ElevatedButton(
                  onPressed: (val)
                      ? () async {
                    enableButton.value = !enableButton.value;
                    await api.submitAttendance(currentLocation).then((isSuccess){
                      if(isSuccess) goToPage(const AttendanceListScreen(), true, context);
                      Fluttertoast.showToast(
                        msg: isSuccess? "Attendance Submitted Successfully" : "Failed to submit Attendance!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    });
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
                    'Submit attendance',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : const Center(
                    child: Text(
                      'Loading ...',
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
      ),
    );
  }

  // void _onMapTapped(TapPosition tapPosition, LatLng tappedPosition) {
  //   selectedLocation.value = tappedPosition;
  // }

  Future<void> _onMapTapped(TapPosition tapPosition, LatLng tappedPosition) async {
    selectedLocation.value = tappedPosition;

    try {
      // Reverse geocode to get the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        tappedPosition.latitude,
        tappedPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          currentLocation = LocationInf(
            lat: tappedPosition.longitude,
            lon: tappedPosition.longitude,
            locationName: "${placemark.name}, ${placemark.country}",
            locationDetails: "${placemark.locality}, ${placemark.country}",
          );
        });
      }
    } catch (e) {
      setState(() {
        currentLocation = LocationInf(
          lat: tappedPosition.longitude,
          lon: tappedPosition.longitude,
          error: e.toString()
        );
      });
    }
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    tileProvider: CancellableNetworkTileProvider(),
  );
}
