import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/core/models/user.dart';
import 'package:halosign/core/services/authentication.dart';

// Authentication Service
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    // Add Google Sign-In logic here (similar to your existing code)
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserRole> getUserRole(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      return UserRole.values[data?['role'] ?? 0]; // Default to 0 if role is missing
    }
    return UserRole.clientUser; // Default role
  }
}

// Current User Provider (FutureProvider)
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = AuthenticationService();
  final user = authService.currentUser;

  if (user != null) {
    final userRole = await authService.getUserRole(user.uid);
    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'Unnamed',
      email: user.email ?? '',
      role: userRole,
    );
  }

  return null;
});

// Function to sign out (invalidate the currentUserProvider)
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = AuthenticationService();
  await authService.signOut();
  ref.invalidate(currentUserProvider); // Invalidate the currentUserProvider after sign out
});

