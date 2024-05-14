import 'package:hive_flutter/adapters.dart';

abstract class HiveBox<T> {
  Future<void> add(T item);
  Future<void> update(int index, T item);
  Future<void> delete(int index);
  Future<T?> get(int index);
  Future<List<T>> getAll();
}

class HiveBoxImpl<T> extends HiveBox<T> {
  final String boxName;

  HiveBoxImpl(this.boxName);

  @override
  Future<void> add(T item) async {
    final box = await Hive.openBox<T>(boxName);
    await box.add(item);
  }

  @override
  Future<void> update(int index, T item) async {
    final box = await Hive.openBox<T>(boxName);
    if (index >= 0 && index < box.length) {
      await box.putAt(index, item);
    } else {
      throw Exception('Index out of bounds');
    }
  }

  @override
  Future<void> delete(int index) async {
    final box = await Hive.openBox<T>(boxName);
    if (index >= 0 && index < box.length) {
      await box.deleteAt(index);
    } else {
      throw Exception('Index out of bounds');
    }
  }

  @override
  Future<T?> get(int index) async {
    final box = await Hive.openBox<T>(boxName);
    if (index >= 0 && index < box.length) {  // Basic check for index validity
      return box.getAt(index);
    } else {
      return null;
    }
  }

  @override
  Future<List<T>> getAll() async {
    final box = await Hive.openBox<T>(boxName);
    return box.values.toList();
  }
}
