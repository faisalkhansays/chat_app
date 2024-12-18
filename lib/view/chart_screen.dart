
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_view_model.dart';
import '../view_model/chat_view_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the messages when the screen is initialized
    Provider.of<ChatViewModel>(context, listen: false).loadMessages(widget.chatId);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatViewModel.messages.length,
              itemBuilder: (context, index) {
                final message = chatViewModel.messages[index];
                return ListTile(
                  title: Text(message.message),
                  subtitle: Text(message.senderId),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter your message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Check if the message is not empty and user is authenticated
                    if (_messageController.text.trim().isNotEmpty && authViewModel.user != null) {
                      chatViewModel.sendMessage(
                        widget.chatId,
                        _messageController.text.trim(),
                        authViewModel.user!.uid,
                      );
                      _messageController.clear(); // Clear the input after sending
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
