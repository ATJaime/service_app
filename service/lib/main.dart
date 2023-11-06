import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:service/controllers/authentication_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service/pages/home.dart';
import 'package:service/pages/login_page.dart';
import 'package:service/providers/firebase_provider.dart';

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
  
  await Permission.locationWhenInUse.isDenied.then(((valueOfPermission) {
          if(valueOfPermission){
            Permission.locationWhenInUse.request();
          }
        }
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
    return ChangeNotifierProvider(
      create: (_) => FirebaseProvider(),
      child: GetMaterialApp(
        title: 'ServiceApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FirebaseAuth.instance.currentUser == null ? const Login(): const Home(),
        debugShowCheckedModeBanner: false,
      )
    );
  }
}
