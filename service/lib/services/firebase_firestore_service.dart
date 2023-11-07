import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;

  static Future<void> createUser({
    required String name,
    required String email,
    required String uid,
  }) async {
    final user = UserModel(
      uid: uid,
      email: email,
      name: name,
    );

    await firestore
        .collection('users')
        .doc(uid)
        .set(user.toJson());
  }

  static Future<void> updateUserData(
          Map<String, dynamic> data) async =>
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  static Future<List<UserModel>> searchUser(
      String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }

  Stream<QuerySnapshot> getUser(String userId){
    return  FirebaseFirestore.instance.collection('users')
      .where('uid', isEqualTo: userId)
      .snapshots();
  }
}
