
import 'dart:async';

import 'package:chat_app/model/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _error;
  bool _isLoading = false;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Stream subscription to listen for user changes
  late final StreamSubscription<User?> _userSubscription;

  AuthViewModel() {
    _userSubscription = _authService.user.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signIn(email, password);
      return true; // Return true if sign-in is successful
    } on FirebaseAuthException catch (e) {
      _error = e.message; // Set the error message from Firebase
      return false; // Return false to indicate failure
    } catch (e) {
      _error = 'An unknown error occurred. Please try again later.';
      return false; // Return false to indicate failure
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
    } catch (e) {
      _error = 'Failed to sign out. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _userSubscription.cancel(); // Cancel the stream subscription
    super.dispose();
  }
}
