
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/agreement.dart';
import 'aggrement_provider.dart';

final pdfUrlProvider = FutureProvider.family<String?, String>((ref, agreementId) async {
  final agreementsCollection = ref.read(agreementProvider).agreementsCollection;

  try {
    final docSnapshot = await agreementsCollection.doc(agreementId).get();

    if (docSnapshot.exists) {
      final agreement = Agreement.fromJson(docSnapshot.data() as Map<String, dynamic>);
      return agreement.pdfUrl; // Return the PDF URL
    } else {
      print('Agreement not found');
      return null;
    }
  } catch (e) {
    print('Error fetching agreement: $e');
    return null; // Handle any errors
  }
});