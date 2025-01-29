import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/views/dashboard/admin_dashboard/selectuser_screen.dart';

import '../../../core/models/agreement.dart';
import '../../../core/providers/aggrement_service_provider.dart';
import '../../../core/providers/pdf_upload_provider.dart';
import '../../../core/services/authentication.dart';


class NewAgreementScreen extends ConsumerStatefulWidget {
  @override
  _NewAgreementScreenState createState() => _NewAgreementScreenState();
}

class _NewAgreementScreenState extends ConsumerState<NewAgreementScreen> {
  File? _selectedFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _selectedSignatories = []; // List to hold selected signatories

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadAndCreateAgreement() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file')),
      );
      return;
    }

    final fileName = "agreements/${DateTime.now().millisecondsSinceEpoch}.pdf";

    try {
      // Get the upload notifier
      final uploadNotifier = ref.read(pdfUploadProvider.notifier);

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Upload PDF
      final pdfUrl = await uploadNotifier.uploadPDF(_selectedFile!);

      // Dismiss loading indicator
      Navigator.of(context).pop();

      if (pdfUrl == null) {
        throw Exception('PDF upload failed');
      }

      // Get current user
      final user = AuthenticationService().currentUser; // Replace with your actual user fetching method

      // Create agreement object
      final newAgreement = Agreement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        createdBy: user!.uid, // Use the actual user ID
        createdAt: DateTime.now(),
        status: AgreementStatus.draft,
        signatories: _selectedSignatories, // Include selected signatories
        pdfUrl: pdfUrl,
      );

      // Save to Firestore
      final agreementService = ref.read(agreementServiceProvider);
      await agreementService.createAgreement(newAgreement);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agreement created successfully!')),
      );

      // Optionally: Navigate back or reset form
      Navigator.of(context).pop();

    } catch (e) {
      // Dismiss loading indicator if still showing
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _selectSignatories() async {
    final selectedUsers = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectUsersScreen(selectedUsers: _selectedSignatories)),
    );
    if (selectedUsers != null) {
      setState(() {
        _selectedSignatories = selectedUsers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Agreement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Agreement Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text(_selectedFile == null ? "Select PDF" : "Change PDF"),
            ),
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Selected: ${_selectedFile!.path.split('/').last}"),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectSignatories, // Call the method to select signatories
              child: Text("Select Signatories (${_selectedSignatories.length})"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadAndCreateAgreement,
              child: const Text("Upload and Save Agreement"),
            ),
          ],
        ),
      ),
    );
  }
}
