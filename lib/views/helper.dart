
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfPageLayout {
  final Rect bounds;
  final double scale;

  PdfPageLayout(
      PdfDocument document,
      int pageIndex,
      double horizontalScrollOffset,
      double verticalScrollOffset,
      double zoomLevel,
      ) :
        scale = zoomLevel,
        bounds = _calculatePageBounds(
          document,
          pageIndex,
          horizontalScrollOffset,
          verticalScrollOffset,
          zoomLevel,
        );

  static Rect _calculatePageBounds(
      PdfDocument document,
      int pageIndex,
      double horizontalScrollOffset,
      double verticalScrollOffset,
      double zoomLevel,
      ) {
    final page = document.pages[pageIndex];
    final pageSize = page.size;
    final scaledWidth = pageSize.width * zoomLevel;
    final scaledHeight = pageSize.height * zoomLevel;

    return Rect.fromLTWH(
      -horizontalScrollOffset,
      -verticalScrollOffset,
      scaledWidth,
      scaledHeight,
    );
  }
}