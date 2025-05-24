import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shersoft/controller/localdb.dart';
import 'package:shersoft/model/localdb.dart';
import 'package:shersoft/view/login&register/login.dart';

class UserController extends ChangeNotifier {
  final FirebaseAuth authentication = FirebaseAuth.instance;
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

   String? uid;
String? companyName;
String? phone;
String? address; 
  Future<String?> loginUser(

      {required String email, required String password,BuildContext? context}) async {

          try {
      await authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("login success");
      notifyListeners();
      return "success";
    } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content:Text(e.code.toString())));

      notifyListeners();
    } catch (e) {
      log('Error: $e');
      notifyListeners();
    }
    return null;
  }

  Future<String?> registerUser(
      {required String email,
      BuildContext? context,
      required String password,
      required String name,
      required String address,
      required String phone}) async {
    if (email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        password.isEmpty ||
        name.isEmpty) {
      log("empty");
    }
    try {
      UserCredential userCredential = await authentication
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          "address": address,
          "company": name,
          "phone": phone,
        });
      }
      log("register success");
      return "register success";
    } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content:Text(e.code.toString())));
      log(e.toString());
    }
    return null;
  }

  Future<void> getUserMetaData() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        uid = user.uid;
        log(user.uid);
        final docs = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();
        if (docs.exists) {
      companyName = docs.data()?['company']; 
      address = docs.data()?['address']; 
      phone = docs.data()?['phone']; 
          log(docs.data().toString());
        }
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }

  Future<void> addAccounts(
      {required String email, required String password}) async {
    final data = UserAcoountDb(email: email, password: password);
    addData(data);
  }

  void logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
