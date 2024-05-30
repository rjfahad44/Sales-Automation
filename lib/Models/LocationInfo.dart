import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationInf {
  double lat, lon;
  String locationName;
  String locationDetails;
  Marker marker;

  LocationInf({
    this.lat = 0.0,
    this.lon = 0.0,
    this.locationName = '',
    this.locationDetails = '',
    Marker? marker,
  }): marker = marker ?? Marker(
  point: const LatLng(23.23, 23.23),
  height: 12,
  width: 12,
  child: ColoredBox(color: Colors.blue[900]!),
  );
}
