import 'package:flutter/material.dart';
import 'package:service/pages/central.dart';
import 'package:get/get.dart';
import 'package:service/controllers/authentication_controller.dart';

void main() {
  Get.put(AuthenticationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiceApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Central(),
    );
  }
}
