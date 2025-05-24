import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shersoft/model/dataModel.dart';
import 'package:flutter/material.dart';

class Datacontroller with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Datamodel> _filteredData = [];

  String selected = "All";

  List<Datamodel> get filteredData => _filteredData;

  Future<void> getdata([String? filter]) async {
       filter ??= "All";
    _filteredData = await fetchData(filter);
    notifyListeners();
  }

  void selectedColor(String filter) {
    if (selected != filter) {
      selected = filter;
      notifyListeners();
    }
  }

  Future<List<Datamodel>> fetchData(String interval) async {
 
    log(interval);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return [];
    }

    String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    Query<Map<String, dynamic>> query = _firestore
        .collection('cash_book')
        .doc(user.uid)
        .collection('transactions');

    switch (interval) {
      case 'Daily':
        query = query.where('date', isEqualTo: today);
        log(today);
        break;

      case 'Weekly':
        DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
        String formattedDateSevenDaysAgo =
            DateFormat('dd-MM-yyyy').format(sevenDaysAgo);
            log(formattedDateSevenDaysAgo);
        query = query.where('date',
            isGreaterThanOrEqualTo: formattedDateSevenDaysAgo);
        break;

      case 'Monthly':
        DateTime firstDayOfMonth =
            DateTime(DateTime.now().year, DateTime.now().month, 1);
        String formattedFirstDayOfMonth =
            DateFormat('dd-MM-yyyy').format(firstDayOfMonth);
        query = query.where('date',
            isGreaterThanOrEqualTo: formattedFirstDayOfMonth);
        break;

      case 'All':
        break;

      default:
        print("Invalid interval selected");
        return [];
    }

    try {
      var querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => Datamodel.fromFireBase(doc.data()))
            .toList();
      } else {
  
        return [];
      }
    } on FirebaseException catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> addDatafireBase({required Datamodel data}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('cash_book')
            .doc(user.uid)
            .collection('transactions')
            .add(data.toJson());
            getdata();
      } on FirebaseException catch (e) {
        log("Firebase error: ${e.message}");
      } catch (e) {
        log("Error adding data: $e");
      }
    } else {
      print("User not logged in.");
    }
  }
}
