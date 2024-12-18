
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String message;
  final String senderId;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.senderId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }

  // Optional: Factory constructor to create ChatMessage from Firestore document
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      message: data['message'] ?? '',
      senderId: data['senderId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}


