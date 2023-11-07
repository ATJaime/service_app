import 'package:flutter/material.dart';
import 'package:service/models/requests.dart';

class HistorialItem extends StatefulWidget{
  const HistorialItem({super.key, required this.request});
  final Request request;
  @override
  State<HistorialItem> createState() => _HistorialItemState();
}
class _HistorialItemState extends State<HistorialItem>{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon((widget.request.state == "Pendiente" ? Icons.pending:
          widget.request.state == "Aceptado" ? Icons.arrow_circle_up_outlined: 
          widget.request.state == "Cancelado" ? Icons.cancel:
          Icons.check_circle
          ), size: 35
        ),     
      title: Text(
      widget.request.description,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold
        )
      )
    );
  }
}