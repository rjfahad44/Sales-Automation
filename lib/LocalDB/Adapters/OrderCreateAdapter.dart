import 'package:hive/hive.dart';
import 'package:sales_automation/Screens/ProductListScreen/Model/Product.dart';

import '../../../global.dart';
import '../../Models/OrderCreate.dart';

@HiveType(typeId: order_model_type_id)
class OrderCreateAdapter extends TypeAdapter<OrderCreate> {

  @override
  OrderCreate read(BinaryReader reader) {
    final int version = reader.readByte();
    switch (version) {
      case 1:
        return OrderCreate(
          deliveryDate: reader.readString(),
          deliveryTime: reader.readString(),
          chemistId: reader.readInt(),
          chemist: reader.readString(),
          chemistAddress: reader.readString(),
          paymentType: reader.readString(),
          products: (reader.readList()).cast<Product>(),
        );
      default:
        throw HiveError("Unknown version: $version for OrderCreate");
    }
  }

  @override
  void write(BinaryWriter writer, OrderCreate obj) {
    writer.writeByte(1); // Version number (update if the model changes)
    writer.writeString(obj.deliveryDate);
    writer.writeString(obj.deliveryTime);
    writer.writeInt(obj.chemistId);
    writer.writeString(obj.chemist);
    writer.writeString(obj.chemistAddress);
    writer.writeString(obj.paymentType);
    writer.writeList(obj.products);
  }

  @override
  int get typeId => order_model_type_id;
}