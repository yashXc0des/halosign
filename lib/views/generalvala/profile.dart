import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/aggrement_service_provider.dart';
import '../../core/providers/authentication_provider.dart';
import '../signupscreen.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreements = ref.watch(agreementsProvider);
    final users = ref.watch(usersProvider);
    final currentUser = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 4.0,
        centerTitle: true,
      ),
      body: currentUser != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your Profile",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 20),
              _buildStatCard("Overview", _buildOverview(agreements, users)),
              SizedBox(height: 30),
              _buildStatCard("Name", Text((currentUser.displayName ?? "No Name Provided"))),
              SizedBox(height: 30),
              _buildStatCard("Email", Text((currentUser.email ?? "No Email Provided"))),
              SizedBox(height: 30),
              _buildSignOutButton(ref, context),
            ],
          ),
        ),
      )
          : Center(child: Text("No user is signed in.", style: TextStyle(fontSize: 18, color: Colors.red))),
    );
  }

  Widget _buildOverview(AsyncValue<List<dynamic>> agreements, AsyncValue<List<dynamic>> users) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn(
          "Total Agreements",
          agreements.when(
            data: (data) => data.length.toString(),
            loading: () => "Loading...",
            error: (_, __) => "Error",
          ),
        ),
        _buildStatColumn(
          "Total Users",
          users.when(
            data: (data) => data.length.toString(),
            loading: () => "Loading...",
            error: (_, __) => "Error",
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, Widget child) {
    return Container(
      width: 400,
      child: Card(

        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.deepPurple.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(WidgetRef ref, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await ref.read(authenticationProvider.notifier).signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleSignInScreen()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 6,
      ),
      child: Text("Sign Out", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }
}
