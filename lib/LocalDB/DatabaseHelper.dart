import 'dart:ffi';

import 'package:hive_flutter/adapters.dart';
import 'package:sales_automation/Screens/ImageCaptureScreen/Model/ImageDataModel.dart';

abstract class HiveBox<T> {
  Future<void> add(T item);
  Future<void> update(int index, T item);
  Future<void> delete(int index);
  Future<T?> get(int index);
  Future<List<T>> getAll();
}

class HiveBoxHelper<T> {
  final String boxName;

  HiveBoxHelper(this.boxName);

  Future<int> add(T item) async {
    final box = await Hive.openBox<T>(boxName);
    return await box.add(item);
  }

  Future<void> update(int index, T item) async {
    final box = await Hive.openBox<T>(boxName);
    if (index >= 0 && index < box.length) {
      await box.putAt(index, item);
    } else {
      throw Exception('Index out of bounds');
    }
  }

  Future<void> delete(int index) async {
    final box = await Hive.openBox<T>(boxName);
    if (index >= 0 && index < box.length) {
      await box.deleteAt(index);
    } else {
      throw Exception('Index out of bounds');
    }
  }

  Future<void> deleteItem(T item) async {
    final box = await Hive.openBox<T>(boxName);
    if (box.isNotEmpty) {
      await box.delete(item);
    } else {
      throw Exception('Data Not Found!!');
    }
  }

  Future<void> deleteAllDataCompletely() async {
    await Hive.deleteFromDisk();
  }

  Future<int> deleteAllData() async {
    final tasksBox = Hive.box<ImageDataModel>(boxName);
    return await tasksBox.clear();
  }

  Future<T?> get(int index) async {
    final box = await Hive.openBox<T>(boxName);
    if (index >= 0 && index < box.length) {
      return box.getAt(index);
    } else {
      return null;
    }
  }

  Future<List<T>> getAll() async {
    final box = await Hive.openBox<T>(boxName);
    return box.values.toList();
  }
}