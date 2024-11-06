
import 'package:hive_flutter/adapters.dart';

class HiveBoxHelper<T> {
  final String boxName;

  HiveBoxHelper(this.boxName);

  getPosition(T item) async {
    try{
      final box = await Hive.openBox<T>(boxName);
      var items = box.values.toList();
      int index = items.indexOf(item);
      return index;
    }catch(e){
      return -1;
    }
  }

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
    if (box.containsKey(item)) {
      await box.delete(item);
    } else {
      throw Exception('CurrentUserData Not Found!!');
    }
  }

  Future<void> deleteAllDataCompletely() async {
    await Hive.deleteFromDisk();
  }

  Future<int> deleteAllData() async {
    final tasksBox = Hive.box<T>(boxName);
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
