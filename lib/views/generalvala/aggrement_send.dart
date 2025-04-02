import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/views/dashboard/admin_dashboard/newaggrement_screen.dart';
import '../../../core/providers/aggrement_service_provider.dart';
import '../dashboard/admin_dashboard/agreement_detail_screen.dart';

class AgreementsScreen1 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsyncValue = ref.watch(currentUserProvider); // Get the current user
    final agreementsAsyncValue = ref.watch(agreementsProvider); // Get all agreements

    Future<void> _refreshAgreements() async {
      ref.invalidate(agreementsProvider); // Refresh the agreements list
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Agreements"),
        backgroundColor: Colors.deepPurple, // Custom app bar color
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if required
            },
          ),
        ],
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
                final filteredAgreements = agreements
                    .where((agreement) => agreement.createdBy == currentUser.id)
                    .toList();

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
                            Text("No agreements found.", style: TextStyle(fontSize: 18, color: Colors.grey)),
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
                        elevation: 5.0, // Subtle shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0), // Rounded corners
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewAgreementScreen()),
          );
        },
        backgroundColor: Colors.deepPurple, // Custom FAB color
        child: Icon(Icons.add, color: Colors.white), // Icon color for contrast
      ),
    );
  }
}
