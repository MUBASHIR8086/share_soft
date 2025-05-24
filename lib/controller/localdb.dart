import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shersoft/model/localdb.dart';

ValueNotifier<List<UserAcoountDb>> valueNotifier = ValueNotifier([]);

Future<void> addData(UserAcoountDb value) async {
  final db = await Hive.openBox<UserAcoountDb>('user-db');
  db.add(value);
  log(db.toString());
  getData();
}

Future<void> getData() async {
  final db = await Hive.openBox<UserAcoountDb>('user-db');
  valueNotifier.value.clear();
  valueNotifier.value.addAll(db.values);
  valueNotifier.notifyListeners();
}
