import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/controllers/user_controller.dart';
import 'package:service/models/user.dart';
import 'package:service/pages/chat_page.dart';
import 'package:service/services/request_service.dart';
import 'package:service/services/firebase_firestore_service.dart';

// ignore: must_be_immutable
class ProposalsBox extends StatefulWidget {

  String requestId;
  ProposalsBox({super.key, required this.requestId});
  @override
  State<ProposalsBox> createState() => _ProposalBoxState();
}

class _ProposalBoxState extends State<ProposalsBox>{

  final RequestService _requestService = RequestService();
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildProposalsList()
            )
          ),
          const SizedBox(height: 5),
        ],
      );
  }


  Widget _buildProposalsList(){
    return StreamBuilder(
      stream: _requestService.getProposalRequests(widget.requestId), 
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text("Error ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.map((document) => _buildProposalItem(document)).toList().isEmpty){ 
          return const Text("Esperando propuestas", style: TextStyle(color: Colors.black));
        }
        return ListView(
          children: snapshot.data!.docs.map((document) => _buildProposalItem(document)).toList(),
        );
      }
    );
  }

  Widget _buildProposalItem(DocumentSnapshot document){
    var data = document.data() as Map<String, dynamic>;
    return StreamBuilder(
      stream: FirebaseFirestoreService().getUser(data['userId']),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text("Error ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        List<UserModel> users =  snapshot.data!.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
        debugPrint(users.length.toString());
        UserModel requesterUser = users.first;
        return Row(
        children: [
          const Icon(Icons.person),
          const SizedBox(width: 30),
            Text(
              requesterUser.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold
                )
              ),
            const SizedBox(width: 40),
            ElevatedButton(
              onPressed: (){
                _requestService.changeRequestState('Aceptada', requesterUser.uid, widget.requestId);
                _userController.setPendingRequest('');
                _userController.stopWaiting();
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => 
                    ChatPage(recieverUserName: requesterUser.name, 
                      recieverUserId: requesterUser.uid)));
              }, 
              child: const Text("Aceptar")
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: (){
                _requestService.deleteProposal(requesterUser.uid, widget.requestId);
              }, 
              child: const Text("Rechazar")
            )
            ]
          );
      }
    );
  }
}