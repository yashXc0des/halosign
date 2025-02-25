import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/aggrement_service_provider.dart';
import '../../../core/providers/authentication_provider.dart';

import '../signupscreen.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreements = ref.watch(agreementsProvider);
    final users = ref.watch(usersProvider);
    final currentUser = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: currentUser != null ? // Check if user is logged in
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings Screen"),
            SizedBox(height: 20),
            Column(
              children: [
                Text("Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard("Total Agreements", agreements.when(
                      data: (data) => data.length.toString(),
                      loading: () => "Loading...",
                      error: (_, __) => "Error",
                    )),
                    _buildStatCard("Total Users", users.when(
                      data: (data) => data.length.toString(),
                      loading: () => "Loading...",
                      error: (_, __) => "Error",
                    )),
                  ],
                ),
                SizedBox(height: 20),
                // Display current user name and email
                _buildStatCard("Name", currentUser.displayName ?? "No Name Provided"),
                _buildStatCard("Email", currentUser.email ?? "No Email Provided"),
              ],
            ),
            SizedBox(height: 20),
            // Sign Out Button
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                await ref.read(authenticationProvider.notifier).signOut();

                // Navigate to Sign In screen after sign-out
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => GoogleSignInScreen()));
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ) :
      // If no user is logged in, show a message
      Center(child: Text("No user is signed in.")),
    );
  }
}

Widget _buildStatCard(String title, String value) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, color: Colors.blue)),
        ],
      ),
    ),
  );
}
