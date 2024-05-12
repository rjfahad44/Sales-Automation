import 'package:flutter/cupertino.dart';

class Item{
  int itemID = 0;
  String itemName = "";
  TextEditingController cont = TextEditingController();

  Item(this.itemID, this.itemName, this.cont);
}