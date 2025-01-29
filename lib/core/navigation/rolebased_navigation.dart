import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../views/dashboard/admin_dashboard/admin_dashbaord.dart';
import '../../views/dashboard/clientAdmin_dashboard/clientAdmin_dashboard.dart';
import '../../views/dashboard/clientUser_dashbaord/clientUser_dashbaord.dart';
import '../../views/dashboard/viewer_dashbaord/viewer_dashbaord.dart';
import '../models/user.dart';
import '../providers/authentication_provider.dart';

class RoleBasedNavigation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authenticationProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Sign In')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Trigger Google Sign-In
              await ref.read(authenticationProvider.notifier).signInWithGoogle();

              // Once sign-in is successful, fetch user role and navigate
              final userRole = await ref.read(authenticationProvider.notifier).currentUserRole;

              // Delay navigation by a short amount to avoid build process issues
              Future.delayed(Duration(milliseconds: 100), () {
                _navigateBasedOnRole(userRole, context);
              });
            },
            child: Text('Sign in with Google'),
          ),
        ),
      );
    }

    // Get user role asynchronously and navigate if the user is already signed in
    return FutureBuilder<UserRole>(
      future: ref.read(authenticationProvider.notifier).currentUserRole,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user role.'));
        }

        final userRole = snapshot.data ?? UserRole.clientUser;

        // Delay navigation by a short amount to avoid build process issues
        Future.delayed(Duration(milliseconds: 100), () {
          _navigateBasedOnRole(userRole, context);
        });

        // Optionally return a placeholder while navigation is happening
        return SizedBox.shrink(); // Empty widget as the navigation is handled immediately
      },
    );
  }

  void _navigateBasedOnRole(UserRole role, BuildContext context) {
    Widget destination;

    switch (role) {
      case UserRole.admin:
        destination = AdminDashboard();
        break;
      case UserRole.clientAdmin:
        destination = ClientadminDashboard();
        break;
      case UserRole.clientUser:
        destination = ClientuserDashbaord();
        break;
      case UserRole.viewer:
        destination = ViewerDashbaord();
        break;
      default:
        destination = Center(child: Text('Unknown role'));
    }

    // Use Navigator.pushReplacement to replace current screen with the role-based screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
