import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shersoft/controller/dataController.dart';
import 'package:shersoft/controller/login.dart';
import 'package:shersoft/firebase_options.dart';
import 'package:shersoft/model/localdb.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shersoft/view/splash.dart';
void main() async {
  try {

    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(UserAcoountDbAdapter());
    // Hive.registerAdapter(HivebackupAdapter());

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("succeess");
  } on Exception catch (e) {
    log(e.toString());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
       ChangeNotifierProvider(create: (context) => Datacontroller(),)
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
