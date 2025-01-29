// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:halosign/core/models/agreement.dart';
// import '../services/agreement.dart';
//
// final agreement_Provider = StateNotifierProvider<AgreementNotifier, AsyncValue<void>>((ref) {
//   return AgreementNotifier();
// });
//
// class AgreementNotifier extends StateNotifier<AsyncValue<void>> {
//   AgreementNotifier() : super(const AsyncValue.data(null));
//
//   Future<void> createAgreement(Agreement agreement) async {
//     state = const AsyncValue.loading();
//     try {
//       await AgreementService().createAgreement(agreement);
//       state = const AsyncValue.data(null);
//     } catch (e) {
//       state = AsyncValue.error(e, StackTrace.current);
//     }
//   }
// }
