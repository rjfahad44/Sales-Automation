

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:sales_automation/Models/LocationInfo.dart';
import 'package:sales_automation/global.dart';

class LocationService {

  Future<LocationInf> getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationInf.error = "Location services are disabled.";
      return locationInf;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationInf.error = "Location permissions are denied.";
        return locationInf;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationInf.error = "Location permissions are permanently denied, we cannot request permissions.";
      return locationInf;
    }

    var position = await Geolocator.getCurrentPosition();

    locationInf.lat = position.latitude;
    locationInf.lon = position.longitude;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        locationInf.locationName = place.name??"No address available";
        locationInf.locationDetails = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      }
      locationInf.error = "No address available";
      return locationInf;
    } catch (e) {
      locationInf.error ="Error: ${e.toString()}";
      return locationInf;
    }
  }

}
