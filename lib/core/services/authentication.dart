import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halosign/core/models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in aborted by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      _syncUserData(userCredential.user);
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }


  // Sign out the user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  // Register a new user (could be done via email/password or other methods)
  Future<UserCredential?> registerWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  // Sync user data (after sign-in or registration)
  Future<void> _syncUserData(User? user) async {
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Check if user data exists, if not create default data
    final userDoc = await userRef.get();
    if (!userDoc.exists) {
      await userRef.set({
        'id': user.uid,
        'name': user.displayName ?? 'Unnamed',
        'email': user.email ?? '',
        'role': UserRole.clientUser.name,
        'permissions': [],
      });
    }

  }

  // Get user role from Firestore
  Future<UserRole> getUserRole(String userId) async {
    try {
      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // Assuming the role is stored in the 'role' field
        final roleString = userDoc.data()?['role'] ?? UserRole.clientUser.name;  // Default to 'clientUser' if role is not found
        return UserRole.values.firstWhere((e) => e.name == roleString, orElse: () => UserRole.clientUser); // Return the corresponding role
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return UserRole.clientUser;  // Return default role if error occurs
  }
  // Get all users from Firestore
  Future<List<UserModel>> getAllUsers() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('users').get();
      final userList = userSnapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel(
          id: doc.id,
          name: data['name'] ?? 'Unnamed',
          email: data['email'] ?? '',
          role: UserRole.values.firstWhere((e) => e.name == data['role'], orElse: () => UserRole.clientUser),
        );
      }).toList();

      return userList;
    } catch (e) {
      print('Error fetching all users: $e');
      return [];
    }
  }



}
