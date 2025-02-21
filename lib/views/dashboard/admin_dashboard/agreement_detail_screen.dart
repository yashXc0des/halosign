import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:halosign/core/models/agreement.dart';
import 'package:halosign/core/models/user.dart'; // Import UserModel if not already imported
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For using Riverpod to fetch user

// Assuming you have a provider that fetches a user by ID
final userProvider = FutureProvider.family<UserModel, String>((ref, userId) async {
  return await getUserById(userId); // Replace with actual user fetching logic
});

Future<UserModel> getUserById(String userId) async {
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (userDoc.exists) {
    return UserModel.fromJson(userDoc.data()!);
  } else {
    throw Exception('User not found');
  }
}

class AgreementDetailScreen extends ConsumerWidget {
  final Agreement agreement;

  AgreementDetailScreen({required this.agreement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFuture = ref.watch(userProvider(agreement.createdBy));

    return Scaffold(
      appBar: AppBar(
        title: Text(agreement.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        agreement.description ?? "No description available",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Created At: ${agreement.createdAt}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Status: ${agreement.status}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              userFuture.when(
                data: (user) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: Icon(Icons.person),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Created by: ${user.name}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${user.email}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error fetching user data'),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (agreement.pdfUrl != null && agreement.pdfUrl!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewScreen(pdfUrl: agreement.pdfUrl!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No PDF available for this agreement')),
                    );
                  }
                },
                icon: Icon(Icons.picture_as_pdf),
                label: Text('Open PDF'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFViewScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF View')),
      body: PDFView(
        filePath: pdfUrl,
      ),
    );
  }
}
