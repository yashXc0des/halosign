import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/core/models/user.dart';
import 'package:halosign/core/models/agreement.dart';
import '../services/agreement.dart';
import '../services/authentication.dart';

// Authentication Provider
final authServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService();
});

// Current User Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.read(authServiceProvider);
  final user = authService.currentUser;
  if (user != null) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'Unnamed',
      email: user.email ?? '',
      role: await authService.getUserRole(user.uid),
    );
  }
  return null;
});

// Agreement Service Provider
final agreementServiceProvider = Provider<AgreementService>((ref) {
  return AgreementService();
});

// Fetch All Agreements
final agreementsProvider = FutureProvider<List<Agreement>>((ref) async {
  final agreementService = ref.read(agreementServiceProvider);
  return await agreementService.getAllAgreements();
});

// User Management (Fetch Users)
final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getAllUsers(); // Ensure this method is implemented correctly
});
