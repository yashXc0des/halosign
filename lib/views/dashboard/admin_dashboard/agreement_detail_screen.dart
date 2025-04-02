import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:halosign/core/models/agreement.dart';
import 'package:halosign/core/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/views/dashboard/admin_dashboard/pdfview_screen.dart';

// User provider
final userProvider = FutureProvider.family<UserModel, String>((ref, userId) async {
  return await getUserById(userId);
});

// Fetch user by ID
Future<UserModel> getUserById(String userId) async {
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (userDoc.exists) {
    return UserModel.fromJson(userDoc.data()!);
  } else {
    throw Exception('User not found');
  }
}

// Signatories provider
final signatoriesProvider = FutureProvider.family<List<UserModel>, List<String>>((ref, userIds) async {
  List<UserModel> users = [];
  for (String userId in userIds) {
    try {
      UserModel user = await getUserById(userId);
      users.add(user);
    } catch (e) {
      print('Error fetching user $userId: $e');
    }
  }
  return users;
});

class AgreementDetailScreen extends ConsumerWidget {
  final Agreement agreement;

  AgreementDetailScreen({required this.agreement});

  String formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFuture = ref.watch(userProvider(agreement.createdBy));
    final signatoriesFuture = ref.watch(signatoriesProvider(agreement.signatories));

    // Define theme colors
    final primaryColor = Color(0xFF4A148C); // Dark purple
    final secondaryColor = Color(0xFF7E57C2); // Medium purple
    final backgroundColor = Color(0xFFF5F5F5); // Light grey background
    final cardColor = Colors.white;
    final textColor = Colors.black87;
    final subtitleColor = Colors.black54;

    final getStatusColor = () {
      switch (agreement.status) {
        case AgreementStatus.draft:
          return Colors.grey;
        case AgreementStatus.pending:
          return Colors.orange;
        case AgreementStatus.signed:
          return Colors.green;
        case AgreementStatus.expired:
          return Colors.red;
        default:
          return Colors.grey;
      }
    };

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          agreement.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Status: ${agreement.status.toString().split('.').last.toUpperCase()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Basic Details Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agreement Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Divider(color: primaryColor.withOpacity(0.2), thickness: 1),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.title, 'Title', agreement.title, textColor, primaryColor),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.description, 'Description',
                          agreement.description ?? "No description available", textColor, primaryColor),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.fingerprint, 'ID', agreement.id, textColor, primaryColor),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.calendar_today, 'Created At',
                          formatDate(agreement.createdAt), textColor, primaryColor),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.update, 'Last Updated',
                          agreement.updatedAt != null ? formatDate(agreement.updatedAt) : 'Not updated', textColor, primaryColor),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.date_range, 'Valid From',
                          formatDate(agreement.validFrom), textColor, primaryColor),
                      SizedBox(height: 12),
                      _buildDetailRow(Icons.event_busy, 'Valid Until',
                          formatDate(agreement.validUntil), textColor, primaryColor),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Creator Card
              userFuture.when(
                data: (user) => Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created By',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Divider(color: primaryColor.withOpacity(0.2), thickness: 1),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: primaryColor,
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.email, size: 16, color: primaryColor),
                                    SizedBox(width: 4),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: subtitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => _buildLoadingCard('Loading creator information...', cardColor, primaryColor),
                error: (error, stack) => _buildErrorCard('Error loading creator information', cardColor, primaryColor),
              ),
              SizedBox(height: 16),

              // Signatories Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Signatories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Divider(color: primaryColor.withOpacity(0.2), thickness: 1),
                      SizedBox(height: 12),
                      signatoriesFuture.when(
                        data: (users) {
                          if (users.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No signatories required',
                                style: TextStyle(color: subtitleColor, fontStyle: FontStyle.italic),
                              ),
                            );
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: users.length,
                            separatorBuilder: (context, index) => Divider(color: primaryColor.withOpacity(0.1)),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final hasSigned = agreement.signedBy.contains(user.id);
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Text(
                                      user.name[0].toUpperCase(),
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                  ),
                                ),
                                title: Text(user.name, style: TextStyle(color: textColor)),
                                subtitle: Text(user.email, style: TextStyle(color: subtitleColor)),
                                trailing: hasSigned
                                    ? Icon(Icons.check_circle, color: Colors.green)
                                    : Icon(Icons.pending, color: Colors.orange),
                              );
                            },
                          );
                        },
                        loading: () => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(color: primaryColor),
                          ),
                        ),
                        error: (error, stack) => Text(
                          'Error loading signatories',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (agreement.pdfUrl != null && agreement.pdfUrl!.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfviewerScreen(pdfUrl: agreement.pdfUrl!),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No PDF available for this agreement')),
                          );
                        }
                      },
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text('View Document'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: primaryColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Sign agreement functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Signing functionality coming soon')),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Sign Agreement'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: agreement.status == AgreementStatus.signed
                            ? Colors.grey
                            : Colors.green,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color textColor, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard(String message, Color cardColor, Color primaryColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: primaryColor),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, Color cardColor, Color primaryColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 40),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}