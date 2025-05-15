import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/views/dashboard/admin_dashboard/newaggrement_screen.dart';
import '../../../core/providers/aggrement_service_provider.dart';
import '../dashboard/admin_dashboard/agreement_detail_screen.dart';

class AgreementsScreen1 extends ConsumerWidget {
  const AgreementsScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsyncValue = ref.watch(currentUserProvider);
    final agreementsAsyncValue = ref.watch(agreementsProvider);

    Future<void> _refreshAgreements() async {
      ref.invalidate(agreementsProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agreements",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Future: Implement search
            },
          ),
        ],
      ),
      body: currentUserAsyncValue.when(
        data: (currentUser) {
          if (currentUser == null) {
            return const Center(
              child: Text(
                "User not found.",
                style: TextStyle(color: Colors.red),
              ),
            );
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                      const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox, size: 60, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              "No agreements found.",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  itemCount: filteredAgreements.length,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final agreement = filteredAgreements[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(Icons.description, color: Colors.deepPurple),
                          title: Text(
                            agreement.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            agreement.description ?? "No description",
                            style: TextStyle(color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AgreementDetailScreen(agreement: agreement),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Error loading agreements: $error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading user: $error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  NewAgreementScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
