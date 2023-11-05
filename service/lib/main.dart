import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:service/pages/central.dart';
import 'package:get/get.dart';
import 'package:service/controllers/authentication_controller.dart';

Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:'Your API key',
      appId:'mobilesdk_app_id',
      messagingSenderId:'project_number',
      projectId:'project_id'
      )
    );
  
  Get.put(AuthenticationController());
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
