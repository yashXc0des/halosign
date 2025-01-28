import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/navigation/rolebased_navigation.dart';
import '../core/providers/authentication_provider.dart';


class GoogleSignInScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In')),
      body: Center(
        child: user == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are not signed in.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Trigger Google Sign-In
                ref.read(authenticationProvider.notifier).signInWithGoogle();
              },
              child: Text('Sign in with Google'),
            ),
          ],
        )
            : RoleBasedNavigation(),
      ),
    );
  }
}
