import 'package:get/get.dart';
class UserController extends GetxController {
  final _username = "".obs;
  final _email = "".obs;
  final _pendingRequest = "".obs;
  final _isWaiting = false.obs;
  final _lookingJob = false.obs;
  final RxList<double> _location = RxList<double>();

  String get username => _username.value;
  String get email => _email.value;
  String get pendingRequest => _pendingRequest.value;
  bool get isWaiting => _isWaiting.value;
  bool get lookingJob => _lookingJob.value;
  

  List<double> get location => _location;

  void setUsername(String username) {
    _username.value = username;
  }
  void setEmail(String email) {
    _email.value = email;
  }

  void setPendingRequest(String pendingRequest) {
    _pendingRequest.value = pendingRequest;
  }

  void waiting(){
    _isWaiting.value = true;
  }

  void looking(){
    _lookingJob.value = true;
  }

  void stopWaiting(){
    _isWaiting.value = false;
  }

  void stopLooking(){
    _lookingJob.value = false;
  }

  void setLocation(lat, long){
    _location.value = [lat, long];
  }

  void reset(){
    _username.value = "";
    _email.value = "";
    _pendingRequest.value = "";
    _isWaiting.value = false;
    _lookingJob.value = false;
    _location.value = [];
  }
}