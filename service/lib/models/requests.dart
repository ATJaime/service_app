import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String requestId;
  final String description;
  String price;
  final String requesterId;
  String freelancerId;
  String state;
  final Timestamp timestamp;

  Request({
    required this.requestId,
    required this.description,
    required this.price,
    required this.requesterId,
    required this.freelancerId,
    required this.state,
    required this.timestamp,
  });

  Map<String, dynamic> toMap(){
    return {
      'requestId': requestId,
      'description': description,
      'price': price,
      'requesterId': requesterId,
      'freelancerId': freelancerId,
      'state': state,
      'timestamp': timestamp,
    };
  }

  factory Request.fromJson(Map<String, dynamic> json){
    return Request(
      requestId: json["requestId"],
      description: json["description"],
      price: json["price"],
      requesterId: json["requesterId"],
      freelancerId: json["freelancerId"],
      state: json["state"],
      timestamp: json["timestamp"],
    );
  }
}



/*

State = [
  'pendiente',
  'aceptada',
  'cancelada',
  'completada',]

*/