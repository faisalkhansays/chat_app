
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_message.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get messages from a specific chat room
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _db.collection("chats/$chatId/messages")
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList(),
    );
  }

  // Send a message to the chat room
  Future<void> sendMessage(String chatId, String message, String userId) async {
    await _db.collection('chats/$chatId/messages').add({
      'message': message,
      'senderId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
