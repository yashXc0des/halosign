import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfviewerScreen extends StatefulWidget {
  final String pdfUrl;  // Declare a variable to hold the pdfUrl

  // Constructor to initialize pdfUrl
  const PdfviewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfviewerScreen> createState() => _PdfviewerScreenState();
}

class _PdfviewerScreenState extends State<PdfviewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,  // Access pdfUrl using widget
      ),
    );
  }
}
