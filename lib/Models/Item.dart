import 'package:flutter/cupertino.dart';

class Item {
  int itemID;
  String itemName;
  TextEditingController textEditingController;

  Item({
    this.itemID = 0,
    this.itemName = "",
    TextEditingController? textEditingController,
  }) : textEditingController = textEditingController ?? TextEditingController();

  factory Item.fromJson(Map<String, dynamic> data) {
    return Item(
      itemID: data['id'],
      itemName: data['text'],
      textEditingController: TextEditingController(),
    );
  }
}