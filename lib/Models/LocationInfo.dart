import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationInf {
  double lat, lon;
  String? locationName;
  String? locationDetails;
  String error;

  LocationInf({
    this.lat = 0.0,
    this.lon = 0.0,
    this.locationName = 'Location not found!!',
    this.locationDetails = 'Location details not found!!',
    this.error = 'Location not found!!.',
    Marker? marker,
  });
}
