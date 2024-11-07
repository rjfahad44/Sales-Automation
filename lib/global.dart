
import 'package:flutter/material.dart';
import 'package:sales_automation/Models/Item.dart';
import 'package:sales_automation/Screens/Order/Models/OrderCreate.dart';

import 'Models/ChemistDropdownResponse.dart';
import 'Models/LocationInfo.dart';
import 'Models/LoginApiResponse.dart';
import 'Models/UserData.dart';

LoginApiResponse userData = LoginApiResponse();
OrderCreate orderCreate = OrderCreate();
OrderCreate orderCreateCopy = OrderCreate();
LocationInf locationInf = LocationInf();
ChemistModel selectedChemist = ChemistModel();
int position = -1;
double screenwidth = 0.0;
Color themeColor = const Color(0xFFFFC680);
Color primaryButtonColor = Color(0xff095f98);
Color primaryMenuColor = const Color(0xff005586);
Color secondaryButtonColor =  Colors.redAccent;
Color primaryTextColor = Colors.black;
Color secondaryTextColor = Colors.white;

// String serverPath = "https://osapi.bunoporibrajok.com";
String serverPath = "http://103.84.252.146:8080";

 const int image_model_type_id = 0;
 const int product_model_type_id = 1;
 const int order_model_type_id = 2;

void goToPage(Widget page, bool isBackPage, BuildContext context) {
 if (isBackPage) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
 } else {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (Route<dynamic> dynamic) => false);
 }
}

