import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service/models/messages.dart';
class ChatService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String content) async{
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message message = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      content: content,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(message.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore.collection('chat_rooms')
      .doc(chatRoomId).collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
  }

   Future<bool> isEmpty(String senderId, String receiverId) async{
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    bool isEmpty = true;
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').get()
    .then((value) { isEmpty = value.docs.isEmpty;});
    return isEmpty;
  }
}