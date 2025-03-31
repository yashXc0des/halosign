import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfviewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfviewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfviewerScreen> createState() => _PdfviewerScreenState();
}

class _PdfviewerScreenState extends State<PdfviewerScreen> {
  double _top = 100.0, _left = 100.0, _width = 200.0, _height = 50.0;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  Future<void> _saveSignatureToPdf() async {
    // Download the PDF
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/temp.pdf";

    // Load PDF document
    final pdfDocument = PdfDocument(inputBytes: await _downloadPdf(widget.pdfUrl, filePath));

    // Convert UI coordinates to PDF coordinates (basic transformation for now)
    double pdfX = _left; // Convert this to actual PDF coordinates
    double pdfY = _top;  // Convert this properly

    // Add signature field
    PdfSignatureField signatureField = PdfSignatureField(
      pdfDocument.pages[0],
      'signatureField',
      bounds: Rect.fromLTWH(pdfX, pdfY, _width, _height),
    );
    pdfDocument.form.fields.add(signatureField);

    // Save modified PDF
    List<int> bytes = await pdfDocument.save();
    File modifiedFile = File(filePath)..writeAsBytesSync(bytes);

    // Upload to Firebase
    //await _uploadToFirebase(modifiedFile);

    // Dispose PDF document
    pdfDocument.dispose();
  }

  Future<List<int>> _downloadPdf(String url, String filePath) async {
    // Simulate downloading the file (You need to implement actual download logic)
    return File(filePath).readAsBytesSync();
  }

  // Future<void> _uploadToFirebase(File file) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   try {
  //     await storage.ref('signed_pdfs/${file.path.split('/').last}').putFile(file);
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Uploaded successfully!")));
  //   } catch (e) {
  //     print("Upload failed: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Stack(
        children: [
          SfPdfViewer.network(widget.pdfUrl, controller: _pdfViewerController),
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _left = (_left + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - _width);
                  _top = (_top + details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - _height);
                });
              },
              child: Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  color: Colors.transparent,
                ),
                child: const Center(child: Text('Signature Box', style: TextStyle(color: Colors.blue))),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSignatureToPdf,
        child: const Icon(Icons.save),
      ),
    );
  }
}
