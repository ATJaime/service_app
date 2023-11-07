import 'package:get/get.dart';
class UserController extends GetxController {
  final _username = "".obs;
  final _email = "".obs;
  final _pendingRequest = "".obs;
  final _isWaiting = false.obs;

  String get username => _username.value;
  String get email => _email.value;
  String get pendingRequest => _pendingRequest.value;
  bool get isWaiting => _isWaiting.value;

  Future<void> setUsername(String username) async {
    _username.value = username;
  }
  Future<void> setEmail(String email) async {
    _email.value = email;
  }

  void setPendingRequest(String pendingRequest) async {
    _pendingRequest.value = pendingRequest;
  }

  void waiting(){
    _isWaiting.value = true;
  }

  void stopWaiting(){
    _isWaiting.value = false;
  }
}