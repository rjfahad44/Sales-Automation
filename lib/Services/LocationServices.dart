import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sales_automation/Models/LocationInfo.dart';
import 'package:sales_automation/global.dart';

class LocationServices{


  Future<LocationInf> getCurrentLocation() async {
    Marker marker = Marker(
      point: LatLng(23.23, 23.23),
      height: 12,
      width: 12,
      child: ColoredBox(color: Colors.blue[900]!),
    );


    LocationInf locationInf = new LocationInf(0, 0, "locationName", marker);


    try {
      Location location = new Location();
      var currentLocation = await location.getLocation();
      double lat = await currentLocation.latitude!;
      double lon = await currentLocation.longitude!;

      marker = Marker(
        point: LatLng(lat, lon),
        height: 12,
        width: 12,
        child: ColoredBox(color: Colors.blue[900]!),
      );

      locationInf = new LocationInf(lat, lon, "locationName", marker);



    } catch (e) {
      locationInf.locationDetails = e.toString();
    }

    return locationInf;
  }

  void enablePermission() async {
    Location location = new Location();
    var _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();
      if (_permission == PermissionStatus.granted) {
        enableLocation();
      } else {
        Fluttertoast.showToast(
            msg: "Allow location permission for attendance",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: themeColor,
            textColor: primaryTextColor,
            fontSize: 16.0);
      }
    } else {
      enableLocation();
    }
  }

  Future<bool> enableLocation() async {
    Location location = new Location();
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      Fluttertoast.showToast(
          msg: serviceEnabled.runtimeType.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: themeColor,
          textColor: primaryTextColor,
          fontSize: 16.0);


    } else {
      Fluttertoast.showToast(
          msg: "Location service enabled",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: themeColor,
          textColor: primaryTextColor,
          fontSize: 16.0);
    }
    return true;
  }




}