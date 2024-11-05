import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_automation/APIs/AuthenticationAPI.dart';
import 'package:sales_automation/LocalDB/PrefsDb.dart';
import 'package:sales_automation/Screens/HomeScreen/HomeScreen.dart';

import '../AuthentationScreen/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var prefs = PrefsDb();
  var authApi = AuthenticationAPI();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      prefs.getStringDataSP(PrefsDb.USER_NAME_AND_PASS).then((value) {
        if (value.isNotEmpty) {
          var jsonData = jsonDecode(value);
          var userName = jsonData[PrefsDb.USER_ID];
          var password = jsonData[PrefsDb.USER_PASS];
          authApi.login(userName, password).then((value) {
            value
                ? goToPage(const HomeScreen(), context)
                : goToPage(const LogInScreen(), context);
          });
        } else {
          goToPage(const LogInScreen(), context);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/agreement.png',
            height: 40,
            width: 40,
          ),
        ],
      ),
    );
  }

  void goToPage(Widget page, BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }
}
