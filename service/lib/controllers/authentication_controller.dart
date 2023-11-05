import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final logged = true.obs;

  bool get isLogged => logged.value;

  Future<void> logOut() async {
    logged.value = false;
  }
}