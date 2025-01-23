import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> pickAndUploadPDFAsAdmin(String title, String validity, String clientEmail) async {
  // Pick a PDF file
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    await uploadPDFToFirebase(file, title, validity, clientEmail);
  } else {
    print("No file selected");
  }
}
Future<void> sendDocumentToClient(String clientEmail, String pdfUrl, String title, String senderEmail) async {
  await FirebaseFirestore.instance.collection('clients').doc(clientEmail).collection('received_documents').add({
    'title': title,
    'pdf_url': pdfUrl,
    'status': 'pending',
    'timestamp': FieldValue.serverTimestamp(),
    'admin_email': senderEmail, // Include sender's email
  });

  print("Document sent to client: $clientEmail");
}


Future<void> uploadPDFToFirebase(File file, String title, String validity, String clientEmail) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    String senderEmail = user?.email ?? "unknown_admin";
    // Default if null


    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('documents/$fileName.pdf');

    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();

    // Store metadata in Firestore
    DocumentReference docRef = await FirebaseFirestore.instance.collection('documents').add({
      'title': title,
      'validity': validity,
      'client_email': clientEmail,
      'admin_email': senderEmail, // Stored senders email , smja bidu
      'pdf_url': downloadURL,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'unsigned'  // Default status
    });

    print("File uploaded successfully: $downloadURL");

    // Send PDF link to client
    await sendDocumentToClient(clientEmail, downloadURL, title,senderEmail);
  } catch (e) {
    print("Error uploading file: $e");
  }
}

class UploadDocumentScreen extends StatefulWidget {
  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController validityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Document")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: validityController, decoration: InputDecoration(labelText: "Validity")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Client Gmail")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                pickAndUploadPDFAsAdmin(
                  titleController.text,
                  validityController.text,
                  emailController.text,
                );
              },
              child: Text("Upload PDF"),
            ),
          ],
        ),
      ),
    );
  }
}

