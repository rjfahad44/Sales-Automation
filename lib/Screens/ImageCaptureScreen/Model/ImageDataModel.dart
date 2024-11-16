import 'package:hive/hive.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';

import '../../../global.dart';

@HiveType(typeId: image_model_type_id)
class ImageDataModel {
  @HiveField(0)
  String imagePath;
  @HiveField(1)
  String doctorName;
  @HiveField(2)
  int doctorId;
  @HiveField(3)
  String address;
  @HiveField(4)
  List<Product> productList;

  ImageDataModel({
    required this.imagePath,
    required this.doctorName,
    required this.doctorId,
    required this.address,
    required this.productList,
  });

  @override
  String toString() {
    return 'ImageDataModel('
        'imagePath: $imagePath,'
        'doctorName: $doctorName'
        'doctorId: $doctorId'
        'address: $address'
        'productList: $productList'
        ')';
  }
}
