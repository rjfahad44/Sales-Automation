import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';
import 'package:sales_automation/Screens/SplashScreen/SplashScreen.dart';
import 'package:sales_automation/global.dart';
import 'LocalDB/Adapters/OrderCreateAdapter.dart';
import 'LocalDB/Adapters/ProductAdapter.dart';
import 'Models/OrderCreate.dart';
import 'Screens/ImageCaptureScreen/Adapter/ImageDataModelAdapter.dart';
import 'Screens/ImageCaptureScreen/Model/ImageDataModel.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Product>(ProductAdapter());
  Hive.registerAdapter<OrderCreate>(OrderCreateAdapter());
  Hive.registerAdapter<ImageDataModel>(ImageDataModelAdapter());
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    screenwidth =  MediaQuery.sizeOf(context).width;
    // Set the status bar color globally
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: themeColor, // Set the status bar background color
    //     statusBarIconBrightness: Brightness.light, // Set the status bar icon color
    //     statusBarBrightness: Brightness.dark, // For iOS status bar color
    //   ),
    // );

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
