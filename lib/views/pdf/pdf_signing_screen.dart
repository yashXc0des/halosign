
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../core/models/agreement.dart';
import 'package:halosign/core/models/signature.dart' as model;
import '../../core/models/signature_box.dart';
import '../../core/providers/aggrement_service_provider.dart';
import '../../core/services/authentication.dart';
import '../../core/services/signature_box_service.dart';
import '../../core/services/signature_service.dart';

class PDFSigningScreen extends ConsumerStatefulWidget {
  final Agreement agreement;

  const PDFSigningScreen({
    Key? key,
    required this.agreement,
  }) : super(key: key);

  @override
  _PDFSigningScreenState createState() => _PDFSigningScreenState();
}

class _PDFSigningScreenState extends ConsumerState<PDFSigningScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final SignatureBoxService _signatureBoxService = SignatureBoxService();
  final SignatureService _signatureService = SignatureService();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  List<SignatureBox> _signatureBoxes = [];
  SignatureBox? _selectedBox;
  bool _isLoading = true;
  bool _showSignaturePad = false;
  int _currentPage = 1;
  String _signatureType = 'drawn'; // 'drawn', 'uploaded', or 'text'
  final TextEditingController _textSignatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSignatureBoxes();
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _textSignatureController.dispose();
    super.dispose();
  }

  Future<void> _loadSignatureBoxes() async {
    try {
      setState(() => _isLoading = true);

      final user = AuthenticationService().currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get signature boxes assigned to the current user
      final boxes = await _signatureBoxService.getSignatureBoxesForUser(
        widget.agreement.id,
        user.uid,
      );

      setState(() {
        _signatureBoxes = boxes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading signature boxes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSignatureDialog(SignatureBox box) {
    setState(() {
      _selectedBox = box;
      _showSignaturePad = true;
    });
  }

  void _resetSignature() {
    _signatureController.clear();
    _textSignatureController.clear();
  }

  Future<void> _saveSignature() async {
    try {
      if (_selectedBox == null) return;

      final user = AuthenticationService().currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      Uint8List? signatureImage;
      String? textSignature;
      model.SignatureType type;

      // Get signature data based on signature type
      switch (_signatureType) {
        case 'drawn':
          signatureImage = await _signatureController.toPngBytes();
          if (signatureImage == null || signatureImage.isEmpty) {
            throw Exception('Please draw a signature');
          }
          type = model.SignatureType.drawn;
          break;
        case 'text':
          textSignature = _textSignatureController.text.trim();
          if (textSignature.isEmpty) {
            throw Exception('Please enter a text signature');
          }
          type = model.SignatureType.text;
          break;
        default:
          throw Exception('Invalid signature type');
      }

      // Create signature
      final signature = await _signatureService.createSignature(
        userId: user.uid,
        agreementId: widget.agreement.id,
        type: type,
        signatureImage: signatureImage,
        textSignature: textSignature,
      );

      // Update signature box with signature ID
      await _signatureBoxService.updateSignatureBox(
        _selectedBox!.id,
        signature.id,
      );

      // Update agreement status if all signatures are now complete
      final agreementService = ref.read(agreementServiceProvider);
      final updatedAgreement = widget.agreement.copyWith(
        signedBy: [...widget.agreement.signedBy, user.uid],
        status: widget.agreement.signatories.length == widget.agreement.signedBy.length + 1
            ? AgreementStatus.signed
            : AgreementStatus.pending,
      );

      await agreementService.updateAgreement(updatedAgreement);

      // Close signature pad
      setState(() {
        _showSignaturePad = false;
        _selectedBox = null;
      });

      // Reload signature boxes
      await _loadSignatureBoxes();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signature saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // If all signatures are complete, navigate back
      if (updatedAgreement.status == AgreementStatus.signed) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving signature: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Agreement",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // PDF Viewer
          SfPdfViewer.network(
            widget.agreement.pdfUrl!,
            controller: _pdfViewerController,
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                _currentPage = details.newPageNumber;
              });
            },
          ),

          // Signature box overlays
          ..._buildSignatureBoxOverlays(),

          // Signature pad
          if (_showSignaturePad)
            _buildSignaturePad(),
        ],
      ),
    );
  }

  List<Widget> _buildSignatureBoxOverlays() {
    final List<Widget> overlays = [];

    // Only show boxes for the current page
    final pageBoxes = _signatureBoxes
        .where((box) => box.pageNumber == _currentPage)
        .toList();

    for (final box in pageBoxes) {
      // Get the current page size
      final pageSize = _pdfViewerController.getPageSize(_currentPage);

      // Convert normalized coordinates to actual coordinates
      final left = box.x * pageSize.width;
      final top = box.y * pageSize.height;
      final width = box.width * pageSize.width;
      final height = box.height * pageSize.height;

      overlays.add(
        Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: GestureDetector(
            onTap: () => _showSignatureDialog(box),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: box.signatureId != null
                      ? Colors.green
                      : Colors.deepPurple,
                  width: 2,
                ),
                color: box.signatureId != null
                    ? Colors.green.withOpacity(0.2)
                    : Colors.deepPurple.withOpacity(0.2),
              ),
              child: Center(
                child: Icon(
                  box.signatureId != null
                      ? Icons.check_circle
                      : Icons.draw,
                  color: box.signatureId != null
                      ? Colors.green
                      : Colors.deepPurple,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return overlays;
  }

  Widget _buildSignaturePad() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Your Signature",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 16),

              // Signature type selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSignatureTypeButton(
                    type: 'drawn',
                    label: 'Draw',
                    icon: Icons.draw,
                  ),
                  SizedBox(width: 16),
                  _buildSignatureTypeButton(
                    type: 'text',
                    label: 'Type',
                    icon: Icons.text_fields,
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Signature input area
              _signatureType == 'drawn'
                  ? _buildDrawSignatureArea()
                  : _buildTextSignatureArea(),

              SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showSignaturePad = false;
                        _selectedBox = null;
                      });
                    },
                    icon: Icon(Icons.close),
                    label: Text("Cancel"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _resetSignature,
                    icon: Icon(Icons.refresh),
                    label: Text("Clear"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _saveSignature,
                    icon: Icon(Icons.check),
                    label: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureTypeButton({
    required String type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _signatureType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _signatureType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.deepPurple,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: isSelected ? Colors.white : Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawSignatureArea() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Signature(
          controller: _signatureController,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextSignatureArea() {
    return Column(
      children: [
        TextField(
          controller: _textSignatureController,
          decoration: InputDecoration(
            labelText: "Type your signature",
            labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.deepPurple.shade300,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepPurple.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepPurple.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: TextStyle(
            fontFamily: 'Pacifico', // Use a signature-like font
            fontSize: 24,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              _textSignatureController.text.isNotEmpty
                  ? _textSignatureController.text
                  : "Your signature will appear here",
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 32,
                color: _textSignatureController.text.isNotEmpty
                    ? Colors.black
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}