import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sales_automation/Screens/LoginScreen.dart';
import 'package:sales_automation/Screens/Order/Adapters/OrderCreateAdapter.dart';
import 'package:sales_automation/Screens/Order/Models/OrderCreate.dart';
import 'package:sales_automation/Screens/Order/Models/Product.dart';
import 'package:sales_automation/Screens/SplashScreen.dart';
import 'package:sales_automation/global.dart';

import 'Screens/ImageCaptureScreen/Adapter/ImageDataModelAdapter.dart';
import 'Screens/ImageCaptureScreen/Model/ImageDataModel.dart';
import 'Screens/Order/Adapters/ProductAdapter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<ImageDataModel>(ImageDataModelAdapter());
  Hive.registerAdapter<Product>(ProductAdapter());
  Hive.registerAdapter<OrderCreate>(OrderCreateAdapter());
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
      home: const SplashScreen(),
    );
  }
}
