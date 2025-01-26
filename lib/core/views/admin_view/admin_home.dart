import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/agreement.dart';
import '../../providers/aggrement_provider.dart';
import '../../services/authentication.dart';


class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _sendTo; // Field for recipient's email
  File? _file;

  // Get an instance of AuthenticationService
  final AuthenticationService _authService = AuthenticationService();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<String?> _uploadFile() async {
    if (_file != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child('agreements/${_file!.path.split('/').last}');
      await fileRef.putFile(_file!);
      return await fileRef.getDownloadURL();
    }
    return null; // Return null if no file is picked
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final String? pdfUrl = await _uploadFile(); // Still fetching the URL but not using it for now

      // Get current user's email from AuthenticationService
      final String? createdBy = _authService.currentUser?.email;

      final agreement = Agreement(
        id: DateTime.now().toString(), // Generate a unique ID
        title: _title!,
        description: _description,
        createdBy: createdBy ?? "default@example.com", // Use current user's email
        createdAt: DateTime.now(),
        pdfUrl: null, // Set pdfUrl to null
        sendTo: _sendTo, // Set the recipient email
      );

      await ref.read(agreementProvider).uploadAgreement(agreement);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agreement uploaded successfully')));
      setState(() {
        _file = null; // Reset file after upload
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Agreement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Send To (Email)'),
                validator: (value) => value!.isEmpty ? 'Please enter an email address' : null,
                onSaved: (value) => _sendTo = value,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Pick a PDF File'),
              ),
              if (_file != null) Text('Selected file: ${_file!.path.split('/').last}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
