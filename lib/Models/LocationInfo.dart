import 'package:flutter_map/flutter_map.dart';

class LocationInf {
  late double lat, lon;
  String locationDetails = "";
  late Marker marker;

  LocationInf(double lat, double lon, String locationName, Marker marker) {
    this.lat = lat;
    this.lon = lon;
    this.locationDetails = locationName;
    this.marker = marker;
  }
}
