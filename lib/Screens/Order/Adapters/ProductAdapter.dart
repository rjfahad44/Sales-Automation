import 'package:hive/hive.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';
import 'package:sales_automation/Screens/Order/Models/OrderCreate.dart';

import '../../../global.dart';

@HiveType(typeId: product_model_type_id)
class ProductAdapter extends TypeAdapter<Product> {

  @override
  Product read(BinaryReader reader) {
    final int version = reader.readByte();
    switch (version) {
      case 1:
        return Product(
          id: reader.readInt(),
          productName: reader.readString(),
          productCode: reader.readString(),
          price: reader.readDouble(),
          productQuantity: reader.readInt(),
        );
      default:
        throw HiveError("Unknown version: $version for OrderCreate");
    }
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeByte(1); // Version number (update if the model changes)
    writer.writeInt(obj.id);
    writer.writeString(obj.productCode);
    writer.writeString(obj.productName);
    writer.writeDouble(obj.price);
    writer.writeInt(obj.productQuantity);
  }

  @override
  int get typeId => product_model_type_id;
}