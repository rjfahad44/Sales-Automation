
import 'package:hive/hive.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';
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
          productId: reader.readInt(),
          productCode: reader.readString(),
          productName: reader.readString(),
          tp: reader.readDouble(),
          productShortName: reader.readString(),
          packSize: reader.readString(),
          discountName: reader.readString(),
          discountValue: reader.readInt(),
          minimumQuantity: reader.readInt(),
          discountType: reader.readString(),
          description: reader.readString(),
          vat: reader.readDouble(),
          mrp: reader.readDouble(),
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
    writer.writeInt(obj.productId);
    writer.writeString(obj.productCode);
    writer.writeString(obj.productName);
    writer.writeDouble(obj.tp);
    writer.writeString(obj.productShortName);
    writer.writeString(obj.packSize);
    writer.writeString(obj.discountName);
    writer.writeInt(obj.discountValue);
    writer.writeInt(obj.minimumQuantity);
    writer.writeString(obj.discountType);
    writer.writeString(obj.description);
    writer.writeDouble(obj.vat);
    writer.writeDouble(obj.mrp);
    writer.writeInt(obj.productQuantity);
  }

  @override
  int get typeId => product_model_type_id;
}