import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Encodable {
  Map<String, dynamic> toJson();
}

typedef Mapper<T> = T Function(dynamic);

abstract class ReadStorage {
  Stream<T> changes<T>(Mapper<T> map);
  Future<T?> find<T>(String key, Mapper<T> map);
}

abstract class WriteStorage {
  Future<void> save<T extends Encodable?>(String key, T value);
  Future<void> remove(String key);
}

abstract class StorageDao implements ReadStorage, WriteStorage {}

@Injectable(as: StorageDao)
class SharedPreferencesStorage implements StorageDao {
  final SharedPreferencesAsync prefs;

  SharedPreferencesStorage(this.prefs);

  final _behaviorSubject = BehaviorSubject(sync: true);
  Stream get stream => _behaviorSubject;

  @override
  Stream<T> changes<T>(Mapper<T> map) => stream.map(map);

  @override
  Future<T?> find<T>(
    String key,
    Mapper<T> map,
  ) async {
    final value = await prefs.getString(key);
    final result = value != null ? map(value) : null;
    _behaviorSubject.add(result);
    return result;
  }

  @override
  Future<void> save<T extends Encodable?>(String key, T value) async {
    if (value == null) {
      await prefs.remove(key);
      return;
    }

    await prefs.setString(key, jsonEncode(value.toJson()));
    _behaviorSubject.add(value);
  }

  @override
  Future<void> remove(String key) async {
    await prefs.remove(key);
    _behaviorSubject.add(null);
  }
}
