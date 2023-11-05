import 'package:service/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:service/pages/home.dart';
import 'package:service/pages/login_page.dart';

class Central extends StatelessWidget {
  const Central({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController = Get.find();
    return Obx(() => authenticationController.isLogged
        ? const Home()
        : const Login());
  }
}