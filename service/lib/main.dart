import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:service/controllers/user_controller.dart';
import 'package:service/pages/central.dart';
import 'package:get/get.dart';
import 'package:service/controllers/authentication_controller.dart';

Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:'AIzaSyDCAo6QmZNF7p0Zmj5_mH08puvLd5wHPh0',
      appId:'com.jaime.service',
      messagingSenderId:'99827661795',
      projectId:'serviceapp-700a0'
      )
    );
  
  Get.put(AuthenticationController());
  Get.put(UserController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ServiceApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Central(),
      debugShowCheckedModeBanner: false,
    );
  }
}
