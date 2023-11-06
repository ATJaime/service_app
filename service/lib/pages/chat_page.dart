import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service/services/chat_service.dart';
import 'package:service/widgets/message_input.dart';

class ChatPage extends StatefulWidget{
  final String recieverUserName;
  final String recieverUserId;
  const ChatPage({super.key, required this.recieverUserName, required this.recieverUserId});
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.recieverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverUserName),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildMessageList()
            )
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              MessageInput(messageController: _messageController),
              IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send, size: 40)
              )
            ]
          ),
          const SizedBox(height: 5),
        ],
      )
    );
  }


  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverUserId, _firebaseAuth.currentUser!.uid), 
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text("Error ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.blue
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(data['content'], style: const TextStyle(color: Colors.white),)
            ) 
          ),
          const SizedBox(height: 10)
        ]
      )
    );
  }
}