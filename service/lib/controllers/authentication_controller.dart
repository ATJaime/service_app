import 'package:get/get.dart';
class AuthenticationController extends GetxController {
  final logged = false.obs;

  bool get isLogged => logged.value;
  

  Future<void> logIn() async {
    logged.value = true;
  }

  Future<void> logOut() async {
    logged.value = false;
  }
}