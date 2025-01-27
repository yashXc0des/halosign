import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import '../services/authentication.dart';


class AuthenticationNotifier extends StateNotifier<User?> {
  final AuthenticationService _authService;

  AuthenticationNotifier(this._authService) : super(null) {
    _initialize();
  }

  // Initialize the user on app start
  Future<void> _initialize() async {
    final user = _authService.currentUser;
    if (user != null) {
      state = user;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      state = userCredential?.user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }
  UserRole get currentUserRole {
    final user = _authService.currentUser;
    if (user != null) {
      // Assuming the role is saved in Firestore
      return _authService.getUserRole(user.uid);
    }
    return UserRole.clientUser; // Default role
  }
}
}

final authenticationProvider = StateNotifierProvider<AuthenticationNotifier, User?>(
      (ref) => AuthenticationNotifier(AuthenticationService()),
);
