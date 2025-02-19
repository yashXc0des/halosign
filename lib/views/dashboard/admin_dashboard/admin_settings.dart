import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/authentication_provider.dart';
import '../../signupscreen.dart';


class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings Screen"),
            SizedBox(height: 20),
            // Sign Out Button
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                await ref.read(authenticationProvider.notifier).signOut();

                // Navigate to Sign In screen after sign-out
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GoogleSignInScreen()));
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
