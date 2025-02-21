// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../services/cloudflare_r2_service.dart';
//
// final pdfUploadProvider = StateNotifierProvider<PdfUploadNotifier, String?>((ref) {
//   return PdfUploadNotifier(ref);
// });
//
// class PdfUploadNotifier extends StateNotifier<String?> {
//   final Ref ref;
//
//   PdfUploadNotifier(this.ref) : super(null);
//
//   Future<String?> uploadPDF(File file) async {
//     final cloudflareR2Service = CloudflareR2Service();
//     String? fileUrl = await cloudflareR2Service.uploadPDF(
//         file,
//         "path/to/your/filename.pdf"
//     );
//     return fileUrl;
//   }
// }