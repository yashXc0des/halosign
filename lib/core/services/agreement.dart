import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:halosign/core/models/agreement.dart';

import 'cloudflare_r2_service.dart';

class AgreementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new agreement
  Future<void> createAgreement(Agreement agreement) async {
    try {
      final agreementRef = _firestore.collection('agreements').doc(agreement.id);
      await agreementRef.set({
        'id': agreement.id,
        'title': agreement.title,
        'description': agreement.description,
        'createdBy': agreement.createdBy, // Store creator ID
        'createdAt': agreement.createdAt.toIso8601String(),
        'updatedAt': agreement.updatedAt?.toIso8601String(), // Store updatedAt
        'status': agreement.status.name,
        'signatories': agreement.signatories,
        'signedBy': agreement.signedBy, // Store signedBy list
        'pdfUrl': agreement.pdfUrl, // Save PDF URL
        'validFrom': agreement.validFrom?.toIso8601String(), // Store start date
        'validUntil': agreement.validUntil?.toIso8601String(), // Store end date
      });
    } catch (e) {
      print('Error creating agreement: $e');
    }
  }

  // Upload the selected PDF file to Cloudflare R2 (or your preferred storage)
  Future<String?> uploadPDF(File file) async {
    try {
      final pdfUploadNotifier = PDFUploadNotifier();
      return await pdfUploadNotifier.uploadPDF(file);
    } catch (e) {
      print('Error uploading PDF: $e');
      return null;
    }
  }

  // Method to pick a PDF file from the local system
  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // Get agreement by ID
  Future<Agreement?> getAgreementById(String agreementId) async {
    try {
      final agreementRef = _firestore.collection('agreements').doc(agreementId);
      final agreementDoc = await agreementRef.get();

      if (agreementDoc.exists) {
        return Agreement.fromJson(agreementDoc.data()!);
      }
    } catch (e) {
      print('Error getting agreement: $e');
    }
    return null;
  }

  // Update agreement status (e.g., Signed, Pending, etc.)
  Future<void> updateAgreementStatus(String agreementId, AgreementStatus status) async {
    try {
      final agreementRef = _firestore.collection('agreements').doc(agreementId);
      await agreementRef.update({
        'status': status.name,
      });
    } catch (e) {
      print('Error updating agreement status: $e');
    }
  }

  // Get agreements for a user (either all or based on role)
  Future<List<Agreement>> getUserAgreements(String userId) async {
    try {
      final agreementsSnapshot = await _firestore
          .collection('agreements')
          .where('signatories', arrayContains: userId)
          .get();

      return agreementsSnapshot.docs
          .map((doc) => Agreement.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting user agreements: $e');
      return [];
    }
  }

  //updates status of agggrement
  Future<void> updateAgreement(Agreement agreement) async {
    try {
      final agreementRef = _firestore.collection('agreements').doc(agreement.id);
      await agreementRef.update({
        'title': agreement.title,
        'description': agreement.description,
        'updatedAt': DateTime.now().toIso8601String(),
        'status': agreement.status.name,
        'signatories': agreement.signatories,
        'signedBy': agreement.signedBy,
        'pdfUrl': agreement.pdfUrl,
        'validFrom': agreement.validFrom?.toIso8601String(),
        'validUntil': agreement.validUntil?.toIso8601String(),
      });
    } catch (e) {
      print('Error updating agreement: $e');
      throw Exception('Failed to update agreement');
    }
  }


  // Get all agreements (Admin)
  Future<List<Agreement>> getAllAgreements() async {
    try {
      print("Fetching agreements from Firestore...");
      final agreementsSnapshot = await _firestore.collection('agreements').get();

      print("Agreements fetched: ${agreementsSnapshot.docs.length}");

      return agreementsSnapshot.docs.map((doc) {
        final data = doc.data();

        // Convert timestamps safely
        String? createdAt;
        if (data["createdAt"] is Timestamp) {
          createdAt = (data["createdAt"] as Timestamp).toDate().toIso8601String();
        } else if (data["createdAt"] is String) {
          createdAt = data["createdAt"];
        }

        String? updatedAt;
        if (data["updatedAt"] is Timestamp) {
          updatedAt = (data["updatedAt"] as Timestamp).toDate().toIso8601String();
        } else if (data["updatedAt"] is String) {
          updatedAt = data["updatedAt"];
        }

        // Convert status safely
        AgreementStatus status = AgreementStatus.draft; // Default value
        if (data["status"] is String) {
          try {
            status = AgreementStatus.values.byName(data["status"]);
          } catch (e) {
            print("Invalid status: ${data["status"]}, using default (draft)");
          }
        }

        // Check validFrom and validUntil (convert Timestamp to String if needed)
        DateTime? validFrom;
        if (data["validFrom"] is Timestamp) {
          validFrom = (data["validFrom"] as Timestamp).toDate();
        }

        DateTime? validUntil;
        if (data["validUntil"] is Timestamp) {
          validUntil = (data["validUntil"] as Timestamp).toDate();
        }

        return Agreement.fromJson({
          "id": doc.id, // Firestore-generated ID
          "title": data["title"] ?? "Untitled",
          "description": data["description"],
          "createdBy": data["createdBy"] ?? "Unknown",
          "createdAt": createdAt ?? DateTime.now().toIso8601String(),
          "updatedAt": updatedAt,
          "status": status.name,
          "signatories": List<String>.from(data["signatories"] ?? []),
          "signedBy": List<String>.from(data["signedBy"] ?? []),
          "pdfUrl": data["pdfUrl"],
          "validFrom": validFrom?.toIso8601String(), // Ensure it's a string if not null
          "validUntil": validUntil?.toIso8601String(), // Ensure it's a string if not null
        });
      }).toList();
    } catch (e, stack) {
      print('Error getting all agreements: $e\n$stack');
      return [];
    }
  }

}
