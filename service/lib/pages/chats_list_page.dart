import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service/providers/firebase_provider.dart';
import 'package:service/widgets/user_item.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget{
  const ChatsScreen({Key? key}) : super(key: key);
  @override
  State<ChatsScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatsScreen>{

  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Consumer<FirebaseProvider>(
        builder: (context, value, child){
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: value.users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) => value
          .users[index].uid != 
          FirebaseAuth.instance.currentUser?.uid ? UserItem(user: value.users[index]): const SizedBox(),
        );
      })
    );
  }
}