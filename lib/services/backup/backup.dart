// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shersoft/model/hiveBackup.dart';
// import 'package:shersoft/model/hivebackup.dart';

// class BackupServices {
//   Future<void> fetchDataFirebase() async {
//     var box = await Hive.openBox<Hivebackup>('userBox');
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       final _firestore = await FirebaseFirestore.instance
//           .collection('cash_book')
//           .doc(user.uid)
//           .collection('transactions')
//           .get();

//       log(_firestore.toString());
//     //  await Hive.openBox<Hivebackup>('userBox');
//       for (var data in _firestore.docs) {
//         final fireBaseData = Hivebackup(
//           cashin: data['cashin'],
//           cashout: data['cashout'],
//           date: data['date'],
//           day: data['day'],
//           time: data['time'],
//         );

//         box.add(fireBaseData);
//       }
//     }
//   }

//   Future<void> backupHiveData() async {
//     final appDir = await getApplicationDocumentsDirectory();
//     final backupFile = File('${appDir.path}/userBox_backup.json');

//     var box = Hive.box<Hivebackup>('userBox');
//     List<Map<String, dynamic>> hiveData = box.values.map((data) {
//       return {
//         'cashin': data.cashin,
//         'cashout': data.cashout,
//         'date': data.date,
//         'day': data.day,
//         'time': data.time,
//       };
//     }).toList();

//     await backupFile.writeAsString(jsonEncode(hiveData));
//     log('Backup saved at: ${backupFile.path}');
//   }

//   Future<void> restoreHiveData() async {
//     final appDir = await getApplicationDocumentsDirectory();
//     final backupFile = File('${appDir.path}/userBox_backup.json');

//     if (!await backupFile.exists()) {
//       log('No backup file found!');
//       return;
//     }

//     var box = await Hive.openBox<Hivebackup>('userBox');
//     String jsonString = await backupFile.readAsString();
//     List<dynamic> restoredData = jsonDecode(jsonString);

//     box.clear(); 
//     for (var item in restoredData) {
//       box.add(Hivebackup(
//         cashin: item['cashin'],
//         cashout: item['cashout'],
//         date: item['date'],
//         day: item['day'],
//         time: item['time'],
//       ));
//     }

//     log('Data restored successfully!');
//   }
// }
