import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart';
import 'chart_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 24),
            CustomButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter both email and password.')),
                  );
                  return;
                }

                // Call the updated signIn method that returns a bool
                final bool success = await authViewModel.signIn(email, password);

                if (success) {
                  // If authentication is successful, navigate to ChatScreen
                  Navigator.pushReplacement(
                    (context),
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(chatId: 'your-chat-id-here'), // Pass the chatId
                    ),
                  );
                } else {
                  // If authentication fails, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authViewModel.error ?? 'Login failed.')),
                  );
                }
              },
              text: authViewModel.isLoading ? 'Logging in...' : 'Login',
            ),
            if (authViewModel.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  authViewModel.error!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;

  const CustomTextField({super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Text(text),
    );
  }
}
