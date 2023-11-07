import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service/models/requests.dart';
import '../models/user.dart';


class FirebaseProvider extends ChangeNotifier{
  List<UserModel> users = [];
  List<Request> requests = [];

  List<UserModel> getUsers(){
    FirebaseFirestore.instance.collection('users')
    .snapshots(includeMetadataChanges: true)
    .listen((users) {
      this.users = users.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      notifyListeners();
     });
     return users;
  }

  List<Request> getRequests(){
    FirebaseFirestore.instance.collection('users_request')
    .snapshots(includeMetadataChanges: true)
    .listen((requests) {
      this.requests = requests.docs.map((doc) => Request.fromJson(doc.data())).toList();
      this.requests.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifyListeners();
     });

     return requests;
  }

}