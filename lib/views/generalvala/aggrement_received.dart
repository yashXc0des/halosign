import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/aggrement_service_provider.dart';
import '../dashboard/admin_dashboard/agreement_detail_screen.dart';

class AgreementsReceivedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsyncValue = ref.watch(currentUserProvider); // Get current user
    final agreementsAsyncValue = ref.watch(agreementsProvider); // Get all agreements

    // Function to refresh the agreements list
    Future<void> _refreshAgreements() async {
      ref.invalidate(agreementsProvider); // Invalidate and refresh the provider
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Agreements Received",style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,color: Colors.white)),
        backgroundColor: Colors.deepPurple, // Custom app bar color
        elevation: 0,
        centerTitle: true,
      ),
      body: currentUserAsyncValue.when(
        data: (currentUser) {
          if (currentUser == null) {
            return Center(child: Text("User not found.", style: TextStyle(color: Colors.red)));
          }

          return RefreshIndicator(
            onRefresh: _refreshAgreements,
            child: agreementsAsyncValue.when(
              data: (agreements) {
                // Filter agreements based on whether current user's ID exists in the signatories list
                final filteredAgreements = agreements.where((agreement) {
                  // Debug the signatories list for each agreement
                  print('Agreement Signatories: ${agreement.signatories}');
                  print('Current User ID: ${currentUser.id}');

                  // Check if the current user's ID is in the signatories list
                  return agreement.signatories?.contains(currentUser.id) ?? false;
                }).toList();

                if (filteredAgreements.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, color: Colors.grey, size: 50),
                            SizedBox(height: 16),
                            Text("No agreements received.", style: TextStyle(fontSize: 18, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: filteredAgreements.length,
                  itemBuilder: (context, index) {
                    final agreement = filteredAgreements[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
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
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error', style: TextStyle(color: Colors.red))),
      ),
    );
  }
}
