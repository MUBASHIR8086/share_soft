// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shersoft/controller/dataController.dart';
// import 'package:shersoft/controller/login.dart';
// import 'package:shersoft/controller/them.dart';
// import 'package:shersoft/firebase_options.dart';
// import 'package:shersoft/model/localdb.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shersoft/view/splash.dart';

// void main() async {
//   try {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Hive.initFlutter();
//     Hive.registerAdapter(UserAcoountDbAdapter());

//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     print("succeess");
//   } on Exception catch (e) {
//     log(e.toString());
//   }
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => UserController(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => Datacontroller(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => ThemeProvider(),
//         )
//       ],
//       child: MaterialApp(
//         theme: ThemeData(
//           textTheme: GoogleFonts.poppinsTextTheme(),
//         ),
//         home: SplashScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
//......................
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shersoft/backup/backup.dart';
import 'package:shersoft/controller/dataController.dart';
import 'package:shersoft/controller/login.dart';
import 'package:shersoft/controller/them.dart';
import 'package:shersoft/firebase_options.dart';
import 'package:shersoft/model/localdb.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shersoft/view/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shersoft/view/totelscreentime/screentime.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppUsageTracker().init();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAcoountDbAdapter());
  FirebaseMessaging.instance.onTokenRefresh.listen(updateFcmToken);
  runApp(const MyApp());
}

Future<void> updateFcmToken(String newToken) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .update({'fcmToken': newToken});
    log("🔄 Token updated: $newToken");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => Datacontroller()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SyncController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
        home: SplashScreen(),
      ),
    );
  }
}
