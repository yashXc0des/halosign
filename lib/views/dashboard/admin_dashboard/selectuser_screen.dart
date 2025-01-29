import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../core/providers/aggrement_service_provider.dart';

class SelectUsersScreen extends ConsumerStatefulWidget {
  final List<String> selectedUsers;
  SelectUsersScreen({required this.selectedUsers});

  @override
  _SelectUsersScreenState createState() => _SelectUsersScreenState();
}

class _SelectUsersScreenState extends ConsumerState<SelectUsersScreen> {
  List<String> _selectedUsers = [];

  @override
  void initState() {
    super.initState();
    _selectedUsers = List.from(widget.selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Select Users")),
      body: usersAsync.when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final isSelected = _selectedUsers.contains(user.id);
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
                onTap: () {
                  setState(() {
                    isSelected ? _selectedUsers.remove(user.id) : _selectedUsers.add(user.id);
                  });
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error loading users")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () => Navigator.pop(context, _selectedUsers),
      ),
    );
  }
}
