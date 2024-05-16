import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_automation/Models/Item.dart';

import 'Models/CurrentLoginUser.dart';
import 'Models/LocationInfo.dart';

CurrentLoginUser currentLoginUser = CurrentLoginUser("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, DateTime.now(), DateTime.now());
double screenwidth = 0.0;
String token = "";
Item selectedChemist = Item(0, "InitChem", TextEditingController());
// Color themeColor = const Color(0xFFFFC600);
Color themeColor = const Color(0xFFFFC680);
Color primaryButtonColor = const Color(0xff095f98);
Color secondaryButtonColor =  Colors.redAccent;
Color primaryTextColor = Colors.black;
Color secondaryTextColor = Colors.white;

// String serverPath = "https://osapi.bunoporibrajok.com";
String serverPath = "http://27.147.221.94:8083";

// late LocationInf cLocationInf;

 const int image_model_type_id = 0;

