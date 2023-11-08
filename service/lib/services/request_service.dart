import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service/models/requests.dart';
class RequestService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addRequest(String description, String price, List<double> location) async{
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    String requestId = '';

    Request request = Request(
      requestId: requestId,
      description: description,
      price: price,
      requesterId: currentUserId,
      freelancerId: '',
      state: 'Pendiente',
      requestLat: location[0].toString(),
      requestLng: location[1].toString(),
      timestamp: timestamp,
    );

    await _firestore.collection('users_request').add(request.toMap())
    .then((DocumentReference doc){
      requestId = doc.id;
    });

    request.requestId = requestId;
    await updateRequestData(request.toMap(), requestId);
    return requestId;
  }

  Future<void> updateRequestData(Map<String, dynamic> data, String requestId) async {
      await _firestore
          .collection('users_request')
          .doc(requestId)
          .update(data);
  }

  Future<void> changeRequestState(String state, String freelancerid, String requestId) async {
      await _firestore
          .collection('users_request')
          .doc(requestId)
          .update({'state': state, 'freelancerId': freelancerid});
  }

  Future<void> deleteRequest(String requestId) async {
      await _firestore
          .collection('users_request')
          .doc(requestId)
          .delete();
  }

  Future<List<Request>> getRequests() async{
    final snapshot = await FirebaseFirestore.instance
        .collection('users_request')
        .where("state", isEqualTo: "Pendiente")
        .get();

    return snapshot.docs
        .map((doc) => Request.fromJson(doc.data()))
        .toList();
  }

  Future<void> proposalRequest(String userId, String requesterId, String requestId) async{
    Map <String, dynamic> data = {
      'userId': userId,
      'requesterId': requesterId,
      'requestId': requestId,
    };
    await _firestore.collection('users_proposals')
      .where('userId', isEqualTo: userId)
      .where('requestId', isEqualTo: requestId).get()
      .then((value) async {
        if(value.docs.isEmpty){
          await _firestore.collection('users_proposals').add(data);
        }
      });
  }

  Stream<QuerySnapshot> getProposalRequests(String requestId){
    return _firestore.collection('users_proposals')
      .where('requestId', isEqualTo: requestId)
      .snapshots();
  }

  Future<void> deleteProposal(String userId, String requestId) async {
      String proposalId = '';
      debugPrint(userId);
      await _firestore
          .collection('users_proposals')
          .where('userId', isEqualTo: userId)
          .where('requestId', isEqualTo: requestId)
          .get()
          .then((doc){
            for (var snapshot in doc.docs){
              proposalId = snapshot.id;
            }
          });
      await _firestore
          .collection('users_proposals')
          .doc(proposalId)    
          .delete();
  }
}