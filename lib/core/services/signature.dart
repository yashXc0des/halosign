import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esign/core/models/signature.dart';

class SignatureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new signature for an agreement
  Future<void> createSignature(Signature signature) async {
    try {
      final signatureRef = _firestore.collection('signatures').doc(signature.id);
      await signatureRef.set({
        'id': signature.id,
        'userId': signature.userId,
        'agreementId': signature.agreementId,
        'type': signature.type.name,
        'signedAt': signature.signedAt.toIso8601String(),
        'signatureUrl': signature.signatureUrl,
        'textSignature': signature.textSignature,
        'ipAddress': signature.ipAddress,
        'deviceInfo': signature.deviceInfo,
      });
    } catch (e) {
      print('Error creating signature: $e');
    }
  }

  // Get signature by ID
  Future<Signature?> getSignatureById(String signatureId) async {
    try {
      final signatureRef = _firestore.collection('signatures').doc(signatureId);
      final signatureDoc = await signatureRef.get();

      if (signatureDoc.exists) {
        return Signature.fromJson(signatureDoc.data()!);
      }
    } catch (e) {
      print('Error getting signature: $e');
    }
    return null;
  }

  // Get all signatures for an agreement
  Future<List<Signature>> getSignaturesForAgreement(String agreementId) async {
    try {
      final signaturesSnapshot = await _firestore
          .collection('signatures')
          .where('agreementId', isEqualTo: agreementId)
          .get();

      return signaturesSnapshot.docs
          .map((doc) => Signature.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting signatures for agreement: $e');
      return [];
    }
  }
}
