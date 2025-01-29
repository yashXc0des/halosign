import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/core/models/user.dart';

import '../../../core/providers/aggrement_service_provider.dart';

class UserManagementScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: users.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final user = data[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text("Role: ${user.role.description}"),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Navigate to Edit User Screen
              },
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error loading users")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add User Screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
