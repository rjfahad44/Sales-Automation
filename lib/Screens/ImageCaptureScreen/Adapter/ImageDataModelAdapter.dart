import 'package:hive/hive.dart';

import '../../../global.dart';
import '../../ProductListScreen/Model/Product.dart';
import '../Model/ImageDataModel.dart';

@HiveType(typeId: image_model_type_id)
class ImageDataModelAdapter extends TypeAdapter<ImageDataModel> {

  @override
  ImageDataModel read(BinaryReader reader) {
    final int version = reader.readByte();
    switch (version) {
      case 1:
        return ImageDataModel(
          imagePath: reader.readString(),
          doctorName: reader.readString(),
          doctorId: reader.readInt(),
          address: reader.readString(),
          productList: (reader.readList()).cast<Product>(),
        );
      default:
        throw HiveError("Unknown version: $version for ImageDataModel");
    }
  }

  @override
  void write(BinaryWriter writer, ImageDataModel obj) {
    writer.writeByte(1); // Version number (update if the model changes)
    writer.writeString(obj.imagePath);
    writer.writeString(obj.doctorName);
    writer.writeInt(obj.doctorId);
    writer.writeString(obj.address);
    writer.writeList(obj.productList);
  }

  @override
  int get typeId => image_model_type_id;
}