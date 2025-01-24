import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esign/core/models/agreement.dart';

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
        'createdAt': agreement.createdAt.toIso8601String(),
        'status': agreement.status.name,
        'signatories': agreement.signatories,
      });
    } catch (e) {
      print('Error creating agreement: $e');
    }
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
}
