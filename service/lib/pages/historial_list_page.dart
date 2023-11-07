import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service/providers/firebase_provider.dart';
import 'package:service/widgets/historial_item.dart';

class HistorialListPage extends StatefulWidget{
  const HistorialListPage({super.key});
  
  @override
  State<HistorialListPage> createState() => _HistorialListPageState();
}

class _HistorialListPageState extends State<HistorialListPage>{
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).getRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial"),
      ),
      body: Consumer<FirebaseProvider>(
        builder: (context, value, child){
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          itemCount: value.requests.length,
          separatorBuilder: (context, index) => const Divider(color: Colors.grey, thickness: 3),
          itemBuilder: (context, index) => value
          .requests[index].requesterId == FirebaseAuth.instance.currentUser?.uid ? 
          HistorialItem(request: value.requests[index]): const SizedBox(),
        );
      })
    );
  }
}