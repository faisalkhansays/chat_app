
import 'dart:async';

import 'package:chat_app/model/chat_service.dart';
import 'package:flutter/foundation.dart';

import '../model/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<ChatMessage> _messages = [];

  // Getter for messages
  List<ChatMessage> get messages => _messages;

  // Declare the subscription type explicitly
  StreamSubscription<List<ChatMessage>>? _subscription;

  // Load messages and listen for changes
  void loadMessages(String chatId) {
    _subscription = _chatService.getMessages(chatId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  // Send message
  Future<void> sendMessage(String chatId, String message, String userId) async {
    await _chatService.sendMessage(chatId, message, userId);
  }

  // Cancel subscription on dispose
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
