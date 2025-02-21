import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/views/dashboard/admin_dashboard/newaggrement_screen.dart';

import '../../../core/providers/aggrement_service_provider.dart';
import 'agreement_detail_screen.dart';

class AgreementsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreementsAsyncValue = ref.watch(agreementsProvider);

    Future<void> _refreshAgreements() async {
      ref.invalidate(agreementsProvider); // Refresh provider data
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Agreements"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAgreements, // Call refresh method on pull-down
        child: agreementsAsyncValue.when(
          data: (agreements) {
            if (agreements.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  Center(child: Text("No agreements found.", style: TextStyle(fontSize: 18, color: Colors.grey))),
                ],
              ); // Wrap in ListView to allow pull-to-refresh
            }
            return ListView.builder(
              itemCount: agreements.length,
              itemBuilder: (context, index) {
                final agreement = agreements[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4.0, // Shadow effect for card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        agreement.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        agreement.description ?? "No description",
                        style: TextStyle(color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgreementDetailScreen(agreement: agreement),
                          ),
                        );
                      },

                    ),
                  ),
                );
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error', style: TextStyle(color: Colors.red))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewAgreementScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
