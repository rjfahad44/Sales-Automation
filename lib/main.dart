import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sales_automation/Screens/Order/Adapters/OrderCreateAdapter.dart';
import 'package:sales_automation/Screens/Order/Models/OrderCreate.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';
import 'package:sales_automation/Screens/SplashScreen/SplashScreen.dart';
import 'package:sales_automation/global.dart';
import 'Screens/ImageCaptureScreen/Adapter/ImageDataModelAdapter.dart';
import 'Screens/ImageCaptureScreen/Model/ImageDataModel.dart';
import 'Screens/Order/Adapters/ProductAdapter.dart';


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
