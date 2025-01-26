import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfViewer extends StatefulWidget {
  final String pdfPath;
  const PdfViewer({super.key, required this.pdfPath});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final Map<String, Uint8List> _signedFields = <String, Uint8List>{};
  PdfDocument? _loadedDocument;
  Uint8List? _documentBytes;
  bool _canCompleteSigning = false;
  bool _canShowToast = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final ByteData data = await rootBundle.load(widget.pdfPath);
      setState(() {
        _documentBytes = data.buffer.asUint8List();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading PDF: $e'))
      );
    }
  }

  Future<void> _signDocument() async {
    if (_loadedDocument != null && _signedFields.isNotEmpty) {
      setState(() {
        _canShowToast = true;
        _canCompleteSigning = false;
      });

      // Simulate document signing process
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> _downloadPdf() async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) return;

      // Get downloads directory
      final Directory? downloadDir = await getExternalStorageDirectory();
      if (downloadDir == null) return;

      // Create file
      final String filePath = '${downloadDir.path}/signed_document.pdf';
      final File file = File(filePath);
      await file.writeAsBytes(_documentBytes!);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to $filePath'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving PDF: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _documentBytes != null ? _downloadPdf : null,
          ),
          ElevatedButton(
            onPressed: _canCompleteSigning ? _signDocument : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _canCompleteSigning
                  ? Theme.of(context).colorScheme.primary
                  : null,
              disabledBackgroundColor: _canCompleteSigning
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              foregroundColor: _canCompleteSigning
                  ? Theme.of(context).colorScheme.onPrimary
                  : null,
            ),
            child: const Text('Complete Signing'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_canShowToast)
            Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text(
                'The agreement has been digitally signed successfully.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          Expanded(
            child: _documentBytes != null
                ? SfPdfViewer.memory(
              _documentBytes!,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                _loadedDocument = details.document;
                _signedFields.clear();
              },
              onFormFieldValueChanged:
                  (PdfFormFieldValueChangedDetails details) {
                if (details.formField is PdfSignatureFormField) {
                  final PdfSignatureFormField signatureField =
                  details.formField as PdfSignatureFormField;
                  if (signatureField.signature != null) {
                    _signedFields[details.formField.name] =
                    signatureField.signature!;
                    setState(() {
                      _canCompleteSigning = true;
                    });
                  } else {
                    _signedFields.remove(details.formField.name);
                    setState(() {
                      _canCompleteSigning = false;
                    });
                  }
                }
              },
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
