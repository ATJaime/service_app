import 'package:flutter/material.dart';
import 'package:service/models/user.dart';
import 'package:service/pages/chat_page.dart';

class UserItem extends StatefulWidget{
  const UserItem({super.key, required this.user});
  final UserModel user;
  @override
  State<UserItem> createState() => _UserItemState();
}
class _UserItemState extends State<UserItem>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       Navigator.push(context, 
        MaterialPageRoute(builder: (context) => 
          ChatPage(recieverUserName: widget.user.name, 
            recieverUserId: widget.user.uid))); 
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          radius: 30,
          child: Icon(Icons.person),
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
          )
      )
    );
  }
}