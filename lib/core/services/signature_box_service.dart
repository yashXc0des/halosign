import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/signature_box.dart';

class SignatureBoxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new signature box
  Future<void> createSignatureBox(SignatureBox box) async {
    await _firestore.collection('signatureBoxes').doc(box.id).set(box.toJson());
  }

  // Get all signature boxes for an agreement
  Future<List<SignatureBox>> getSignatureBoxesByAgreement(String agreementId) async {
    final snapshot = await _firestore
        .collection('signatureBoxes')
        .where('agreementId', isEqualTo: agreementId)
        .get();

    return snapshot.docs.map((doc) => SignatureBox.fromJson(doc.data())).toList();
  }

  // Get signature boxes assigned to a specific user for an agreement
  Future<List<SignatureBox>> getSignatureBoxesForUser(String agreementId, String userId) async {
    final snapshot = await _firestore
        .collection('signatureBoxes')
        .where('agreementId', isEqualTo: agreementId)
        .where('assignedToUserId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => SignatureBox.fromJson(doc.data())).toList();
  }

  // Update signature box with signature ID once signed
  Future<void> updateSignatureBox(String boxId, String signatureId) async {
    await _firestore.collection('signatureBoxes').doc(boxId).update({
      'signatureId': signatureId,
    });
  }
}