import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const MaterialApp(
    home: PdfViewerScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  PdfDocument? _loadedDocument;
  Uint8List? _documentBytes;
  bool _canShowToast = false;
  String? _errorMessage;
  bool _isPlacingSignature = false;
  Offset _normalizedOffset = Offset.zero;
  Size _signatureSize = const Size(100, 50);
  int? _currentPage;
  double _scale = 1.0;
  double _initialScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final bytes = await _readAsset('files/lease_agreement.pdf');
      if (mounted) {
        setState(() {
          _documentBytes = Uint8List.fromList(bytes);
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load document: ${e.toString()}';
          _documentBytes = Uint8List(0);
        });
      }
    }
  }

  Future<List<int>> _readAsset(String name) async {
    try {
      final ByteData data = await rootBundle.load('assets/$name');
      return data.buffer.asUint8List();
    } catch (e) {
      throw Exception('Error loading asset $name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitally sign the agreement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _startSignatureProcess,
            tooltip: 'Add Signature Box',
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          if (_isPlacingSignature)
            Positioned(
              left: _normalizedOffset.dx,
              top: _normalizedOffset.dy,
              child: GestureDetector(
                onScaleStart: (details) {
                  _initialScale = _scale;
                },
                onScaleUpdate: (details) {
                  final RenderBox stackBox = context.findRenderObject() as RenderBox;
                  final currentLocalFocalPoint = stackBox.globalToLocal(details.focalPoint);
                  final previousFocalPointGlobal = details.focalPoint - details.focalPointDelta;
                  final previousLocalFocalPoint = stackBox.globalToLocal(previousFocalPointGlobal);
                  final localDelta = currentLocalFocalPoint - previousLocalFocalPoint;

                  setState(() {
                    _normalizedOffset += localDelta;
                    _scale = (_initialScale * details.scale).clamp(0.5, 4.0);
                  });
                },
                onScaleEnd: (details) {
                  _updateSignatureSize();
                },
                child: Transform.scale(
                  scale: _scale,
                  child: Container(
                    width: _signatureSize.width,
                    height: _signatureSize.height,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          if (_isPlacingSignature)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _openSignatureCanvas,
                  child: const Text('Sign Here'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_documentBytes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_documentBytes!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load document'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDocument,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (_canShowToast)
          _buildStatusBanner(
            'Signature placed successfully!',
            Colors.green,
          ),
        if (_errorMessage != null)
          _buildStatusBanner(_errorMessage!, Colors.red),
        Expanded(
          child: SfPdfViewer.memory(
            _documentBytes!,
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              if (mounted) {
                setState(() {
                  _loadedDocument = details.document;
                });
              }
            },
            onTap: (PdfGestureDetails details) {
              if (_isPlacingSignature) {
                _handlePdfTap(details);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBanner(String message, Color color) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _startSignatureProcess() {
    setState(() {
      _isPlacingSignature = true;
      _normalizedOffset = Offset.zero;
      _signatureSize = const Size(100, 50);
      _scale = 1.0;
    });
  }

  void _handlePdfTap(PdfGestureDetails details) {
    if (!_isPlacingSignature) return;

    setState(() {
      _currentPage = details.pageNumber;
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(details.position);
      _normalizedOffset = localPosition - Offset(_signatureSize.width/2, _signatureSize.height/2);
    });
  }

  void _updateSignatureSize() {
    setState(() {
      _signatureSize = Size(
        _signatureSize.width * _scale,
        _signatureSize.height * _scale,
      );
      _scale = 1.0;
    });
  }

  void _openSignatureCanvas() {
    if (_currentPage == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SignatureCanvas(
        onSave: (Uint8List signature) async {
          final page = _loadedDocument!.pages[_currentPage! - 1];
          final pageSize = page.size;
          final zoomLevel = _pdfViewerController.zoomLevel;

          final pdfX = (_normalizedOffset.dx + _signatureSize.width/2) / zoomLevel;
          final pdfY = (_normalizedOffset.dy + _signatureSize.height/2) / zoomLevel;
          final correctedY = pageSize.height - pdfY;

          final image = PdfBitmap(signature);
          page.graphics.drawImage(
            image,
            Rect.fromLTWH(
              pdfX - (_signatureSize.width/2 / zoomLevel),
              correctedY - (_signatureSize.height/2 / zoomLevel),
              _signatureSize.width / zoomLevel,
              _signatureSize.height / zoomLevel,
            ),
          );

          final bytes = await _loadedDocument!.save();
          setState(() {
            _documentBytes = bytes as Uint8List?;
            _isPlacingSignature = false;
            _canShowToast = true;
          });
          _hideToastAfterDelay();
        },
      ),
    );
  }

  void _hideToastAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _canShowToast = false);
      }
    });
  }

  @override
  void dispose() {
    _loadedDocument?.dispose();
    super.dispose();
  }
}

class SignatureCanvas extends StatefulWidget {
  final Function(Uint8List) onSave;

  const SignatureCanvas({super.key, required this.onSave});

  @override
  _SignatureCanvasState createState() => _SignatureCanvasState();
}

class _SignatureCanvasState extends State<SignatureCanvas> {
  List<Offset> points = [];
  final GlobalKey _signatureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      child: Column(
        children: [
          const Text(
            'Draw your signature below:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  points = [...points, details.localPosition];
                });
              },
              onPanEnd: (DragEndDetails details) {
                points.add(Offset.infinite);
              },
              child: RepaintBoundary(
                key: _signatureKey,
                child: CustomPaint(
                  painter: SignaturePainter(points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => points = []),
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (points.isEmpty) return;
                  final image = await _captureSignature();
                  widget.onSave(image);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Uint8List> _captureSignature() async {
    final boundary = _signatureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => oldDelegate.points != points;
}