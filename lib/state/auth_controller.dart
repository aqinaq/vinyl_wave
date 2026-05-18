import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/app_config.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSignedIn => _user != null;
  String? get errorMessage => _errorMessage;
  bool get isAdmin {
    final email = _user?.email;

    if (email == null) {
      return false;
    }

    return AppConfig.adminEmails.contains(email.toLowerCase());
  }

  AuthController() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }


  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _clearError();
    } on FirebaseAuthException catch (error) {
      _setError(_friendlyError(error));
    } catch (_) {
      _setError('Something went wrong while creating your account.');
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _clearError();
    } on FirebaseAuthException catch (error) {
      _setError(_friendlyError(error));
    } catch (_) {
      _setError('Something went wrong while signing in.');
    }
  }

  Future<void> signInAnonymously() async {
    try {
      _setLoading();

      await _auth.signInAnonymously();

      _clearError();
    } on FirebaseAuthException catch (error) {
      _setError(_friendlyError(error));
    } catch (_) {
      _setError('Something went wrong while continuing as guest.');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _clearError();
  }

  void clearError() {
    _clearError();
  }

  void _setLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  String _friendlyError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try signing in.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return error.message ?? 'Authentication failed.';
    }
  }
}