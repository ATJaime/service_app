import 'package:flutter/material.dart';
import 'package:service/widgets/my_text_field.dart';

class MessageInput extends StatefulWidget{
  const MessageInput({super.key, required this.messageController});
  final TextEditingController messageController;
  @override
  State<MessageInput> createState() => _MessageInputState();
}
class _MessageInputState extends State<MessageInput>{
  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: MyTextField(
            controller: widget.messageController,
            hintText: 'Escribir',
          )
        );
  }
}