import 'package:esign/core/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class Admin_SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Sign out the user using Riverpod
            await ref.read(authProvider).signOut(); // Use the provider variable directly
            // Navigate back to the sign-in screen
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signup_view()));// Update with your sign-in route
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
