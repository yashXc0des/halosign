import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserEmailProvider = Provider<String?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user?.email; // Return the email or null if not authenticated
});
