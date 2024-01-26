import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'package:qr_code/app/modules/loading/splash_screen.dart';
import 'package:qr_code/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const SplashScreen();

          // .....
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: false),
            title: "QR-CODE",
            initialRoute: (snapshot.hasData) ? Routes.HOME : Routes.LOGIN,
            getPages: AppPages.routes,
          );
        });
  }
}
