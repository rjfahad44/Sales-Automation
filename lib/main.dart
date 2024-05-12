import 'package:flutter/material.dart';
import 'package:sales_automation/Screens/LoginScreen.dart';
import 'package:sales_automation/global.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    screenwidth =  MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryTextColor, primary: primaryTextColor, ),
        useMaterial3: true,
      ),
      home: LogInScreen(),
    );
  }
}
