import 'package:get/get.dart';
class UserController extends GetxController {
  final _username = "".obs;
  final _email = "".obs;

  String get username => _username.value;
  String get email => _email.value;
  

  Future<void> setUsername(String username) async {
    _username.value = username;
  }
  Future<void> setEmail(String email) async {
    _email.value = email;
  }
}