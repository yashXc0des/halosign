import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<Size> getPageSize(Uint8List pdfBytes, int pageNumber) async {
  try {
    // Load the PDF document from bytes
    final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

    // Ensure page number is valid
    if (pageNumber > 0 && pageNumber <= document.pages.count) {
      final PdfPage page = document.pages[pageNumber - 1];
      final Size pageSize = Size(page.size.width, page.size.height);

      // Clean up
      document.dispose();

      return pageSize;
    } else {
      document.dispose();
      throw Exception('Invalid page number');
    }
  } catch (e) {
    // Fallback in case of error
    debugPrint('Error loading PDF page size: $e');
    return _defaultPageSize;}}
