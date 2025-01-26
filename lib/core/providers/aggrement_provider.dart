import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/agreement.dart';

final agreementProvider = Provider((ref) => AgreementService());

class AgreementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get agreementsCollection =>
      _firestore.collection('agreements');

  Future<void> uploadAgreement(Agreement agreement) async {
    await agreementsCollection.doc(agreement.id).set(agreement.toJson());
  }
}

final currentUserEmailProvider = Provider<String?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user?.email;
});

final agreementsProvider = StateNotifierProvider<AgreementNotifier, List<Agreement>>((ref) {
  return AgreementNotifier(ref);
});

class AgreementNotifier extends StateNotifier<List<Agreement>> {
  AgreementNotifier(Ref ref) : super([]) {
    _loadAgreements(ref);
  }

  Future<void> _loadAgreements(Ref ref) async {
    final currentUserEmail = ref.read(currentUserEmailProvider);

    if (currentUserEmail == null) {
      print('No user is logged in.');
      state = [];
      return;
    }

    final agreementsCollection = ref.read(agreementProvider).agreementsCollection;

    try {
      final querySnapshot = await agreementsCollection
          .where('sendTo', isEqualTo: currentUserEmail)
          .get();

      final agreements = querySnapshot.docs.map((doc) {
        try {
          return Agreement.fromJson(doc.data() as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing document: ${doc.id}, $e');
          return null; // Skip invalid document
        }
      }).whereType<Agreement>().toList(); // Filter out nulls

      state = agreements;
    } catch (e) {
      print('Error fetching agreements: $e');
      state = []; // Set empty list if an error occurs
    }
  }

  Future<void> rejectAgreement(Ref ref,String id) async {
    final agreementsCollection = ref.read(agreementProvider).agreementsCollection;

    try {
      await agreementsCollection.doc(id).update({'status': AgreementStatus.rejected.name});
      _loadAgreements(ref); // Reload agreements afteAr the update
    } catch (e) {
      print('Error rejecting agreement: $e');
    }
  }

  Future<void> openPdf(String pdfUrl) async {
    // Open PDF using your preferred PDF viewer library
    // Example: using url_launcher
    final Uri pdfUri = Uri.parse(pdfUrl);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri);
    } else {
      print('Could not launch $pdfUrl');
    }
  }
}
