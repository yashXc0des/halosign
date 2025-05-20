import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Add this import
import 'package:uuid/uuid.dart';
import '../../core/models/agreement.dart';
import '../../core/models/signature_box.dart';
import '../../core/services/signature_box_service.dart';
import '../../core/services/authentication.dart';

class PDFEditorScreen extends ConsumerStatefulWidget {
  final Agreement agreement;
  final List<String> selectedSignatories;

  const PDFEditorScreen({
    Key? key,
    required this.agreement,
    required this.selectedSignatories,
  }) : super(key: key);

  @override
  _PDFEditorScreenState createState() => _PDFEditorScreenState();
}

class _PDFEditorScreenState extends ConsumerState<PDFEditorScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final SignatureBoxService _signatureBoxService = SignatureBoxService();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Map<String, List<SignatureBox>> _signatoryBoxes = {};
  String? _selectedUserId;
  int _currentPage = 1;
  bool _isPlacingBox = false;
  Offset? _boxStart;
  Offset? _boxEnd;

  // Default page size to use until actual size is available
  Size _defaultPageSize = Size(595, 842); // A4 size in points

  @override
  void initState() {
    super.initState();
    _initializeSignatoryBoxes();
  }

  void _initializeSignatoryBoxes() {
    for (final userId in widget.selectedSignatories) {
      _signatoryBoxes[userId] = [];
    }
    _selectedUserId = widget.selectedSignatories.isNotEmpty ? widget.selectedSignatories.first : null;
  }

  // Get the page size - helper method
  Size getPageSize(int pageNumber) {
    final pdfViewerState = _pdfViewerKey.currentState;

    if (pdfViewerState != null) {
      final pdfDocument = pdfViewerState.pdfDocument;
      if (pdfDocument != null) {
        final pageCount = pdfDocument.pages.count;
        if (pageNumber > 0 && pageNumber <= pageCount) {
          final page = pdfDocument.pages[pageNumber - 1];
          final width = page.size.width;
          final height = page.size.height;
          return Size(width, height);
        }
      }
    }

    // Fallback to default page size if unable to retrieve from the document
    return _defaultPageSize;
  }

  // Convert screen coordinates to normalized coordinates (0-1)
  Map<String, double> _normalizeCoordinates(Offset start, Offset end, Size pageSize) {
    double left = math.min(start.dx, end.dx) / pageSize.width;
    double top = math.min(start.dy, end.dy) / pageSize.height;
    double width = (end.dx - start.dx).abs() / pageSize.width;
    double height = (end.dy - start.dy).abs() / pageSize.height;

    // Ensure values are between 0 and 1
    left = math.max(0, math.min(1, left));
    top = math.max(0, math.min(1, top));
    width = math.max(0, math.min(1, width));
    height = math.max(0, math.min(1, height));

    return {
      'left': left,
      'top': top,
      'width': width,
      'height': height,
    };
  }

  void _addSignatureBox() {
    if (_boxStart != null && _boxEnd != null && _selectedUserId != null) {
      // Get the current page size using our custom method
      final pageSize = getPageSize(_currentPage);

      // Normalize coordinates
      final coords = _normalizeCoordinates(_boxStart!, _boxEnd!, pageSize);

      // Create a new signature box
      final box = SignatureBox(
        id: const Uuid().v4(),
        agreementId: widget.agreement.id,
        assignedToUserId: _selectedUserId!,
        pageNumber: _currentPage.toDouble(),
        x: coords['left']!,
        y: coords['top']!,
        width: coords['width']!,
        height: coords['height']!,
        signatureId: null,
      );

      // Add to local state
      setState(() {
        _signatoryBoxes[_selectedUserId]!.add(box);
        _boxStart = null;
        _boxEnd = null;
      });
    }
  }

  Future<void> _saveSignatureBoxes() async {
    try {
      // Save all signature boxes to Firestore
      for (final userId in _signatoryBoxes.keys) {
        for (final box in _signatoryBoxes[userId]!) {
          await _signatureBoxService.createSignatureBox(box);
        }
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signature boxes saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop(true);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving signature boxes: $e'),
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
          "Place Signature Boxes",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: _saveSignatureBoxes,
            icon: Icon(Icons.save, color: Colors.white),
            label: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSignatorySelector(),
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                if (_isPlacingBox && _selectedUserId != null) {
                  setState(() {
                    _boxStart = details.localPosition;
                  });
                }
              },
              onPanUpdate: (details) {
                if (_isPlacingBox && _boxStart != null) {
                  setState(() {
                    _boxEnd = details.localPosition;
                  });
                }
              },
              onPanEnd: (details) {
                if (_isPlacingBox) {
                  _addSignatureBox();
                }
              },
              child: Stack(
                children: [
                  SfPdfViewer.network(
                    widget.agreement.pdfUrl!,
                    controller: _pdfViewerController,
                    key: _pdfViewerKey,
                    onPageChanged: (PdfPageChangedDetails details) {
                      setState(() {
                        _currentPage = details.newPageNumber;
                      });
                    },
                  ),

                  // Render existing signature boxes for the current page
                  ..._buildSignatureBoxOverlays(),

                  // Render the box being created
                  if (_isPlacingBox && _boxStart != null && _boxEnd != null)
                    Positioned(
                      left: math.min(_boxStart!.dx, _boxEnd!.dx),
                      top: math.min(_boxStart!.dy, _boxEnd!.dy),
                      width: (_boxEnd!.dx - _boxStart!.dx).abs(),
                      height: (_boxEnd!.dy - _boxStart!.dy).abs(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple, width: 2),
                          color: Colors.deepPurple.withOpacity(0.2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildControlBar(),
        ],
      ),
    );
  }

  List<Widget> _buildSignatureBoxOverlays() {
    final List<Widget> overlays = [];

    // Only show boxes for the current page
    for (final userId in _signatoryBoxes.keys) {
      final pageBoxes = _signatoryBoxes[userId]!
          .where((box) => box.pageNumber == _currentPage)
          .toList();

      for (final box in pageBoxes) {
        // Get the current page size using our custom method
        final pageSize = getPageSize(_currentPage);

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
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: userId == _selectedUserId
                      ? Colors.deepPurple
                      : Colors.grey,
                  width: 2,
                ),
                color: userId == _selectedUserId
                    ? Colors.deepPurple.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
              ),
              child: Center(
                child: Icon(
                  Icons.draw,
                  color: userId == _selectedUserId
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
              ),
            ),
          ),
        );
      }
    }

    return overlays;
  }

  Widget _buildSignatorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a signatory to place signature boxes:",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.selectedSignatories.map((userId) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      userId.split('@').first,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: _selectedUserId == userId
                            ? Colors.white
                            : Colors.deepPurple,
                      ),
                    ),
                    selected: _selectedUserId == userId,
                    selectedColor: Colors.deepPurple,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (selected) {
                      setState(() {
                        _selectedUserId = selected ? userId : null;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _pdfViewerController.previousPage();
                },
                icon: Icon(Icons.navigate_before),
                color: Colors.deepPurple,
              ),
              Text(
                "Page $_currentPage",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () {
                  _pdfViewerController.nextPage();
                },
                icon: Icon(Icons.navigate_next),
                color: Colors.deepPurple,
              ),
            ],
          ),
          Row(
            children: [
              Switch(
                value: _isPlacingBox,
                onChanged: (value) {
                  setState(() {
                    _isPlacingBox = value;
                  });
                },
                activeColor: Colors.deepPurple,
              ),
              Text(
                _isPlacingBox ? "Drawing Mode On" : "Viewing Mode",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}