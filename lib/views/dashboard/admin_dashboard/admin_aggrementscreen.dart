import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/views/dashboard/admin_dashboard/newaggrement_screen.dart';


import '../../../core/providers/aggrement_service_provider.dart';

class AgreementsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreementsAsyncValue = ref.watch(agreementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Agreements"),
      ),
      body: agreementsAsyncValue.when(
        data: (agreements) {
          if (agreements.isEmpty) {
            return Center(child: Text("No agreements found."));
          }
          return ListView.builder(
            itemCount: agreements.length,
            itemBuilder: (context, index) {
              final agreement = agreements[index];
              return ListTile(
                title: Text(agreement.title),
                subtitle: Text(agreement.description ?? "No description"),
                onTap: () {
                  // Navigate to agreement detail screen or action
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewAgreementScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
