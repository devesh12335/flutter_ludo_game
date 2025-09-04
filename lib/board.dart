import 'dart:math' as Math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ludo_game/models/cell.dart';

/// Simple Ludo board that paints the board and places tappable token widgets
/// on top. Call [onTokenTap] to notify parent which player/color and which
/// token index was tapped.
class LudoBoard extends StatefulWidget {
  final double size;
  final bool showGrid;
  final Map<LudoColor, List<Cell>> tokens;
  final List<Cell> highlightCells;
  final void Function(LudoColor color, int tokenIndex)? onTokenTap;

  const LudoBoard({
    super.key,
    this.size = 360,
    this.showGrid = false,
    this.tokens = const {},
    this.highlightCells = const <Cell>[],
    this.onTokenTap,
  });

  @override
  State<LudoBoard> createState() => _LudoBoardState();
}

class _LudoBoardState extends State<LudoBoard> {
  ui.Image? _background;

  @override
  void initState() {
    super.initState();
    _loadBoardImage("assets/board.png"); // 👈 put your asset path
  }

  Future<void> _loadBoardImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      _background = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cell = widget.size / _LudoPainter.n;
    final double tokenSize = cell * 0.72;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Paint the board (with background image if loaded)
          CustomPaint(
            size: Size.square(widget.size),
            painter: _LudoPainter(
              background: _background,
              showGrid: widget.showGrid,
              tokens: const {},
              highlightCells: widget.highlightCells,
              showCellLabels: true,
            ),
          ),

          // Tokens
          ...widget.tokens.entries.expand((entry) {
            final LudoColor color = entry.key;
            final List<Cell> cellList = entry.value;

            return List.generate(cellList.length, (i) {
              final Cell pos = cellList[i];
              final double left = pos.c * cell + (cell - tokenSize) / 2;
              final double top = pos.r * cell + (cell - tokenSize) / 2;

              return Positioned(
                left: left,
                top: top,
                width: tokenSize,
                height: tokenSize,
                child: GestureDetector(
                  onTap: () => widget.onTokenTap?.call(color, i),
                  child: _buildToken(color),
                ),
              );
            });
          }),
        ],
      ),
    );
  }

  Widget _buildToken(LudoColor color) {
    return Container(
      decoration: BoxDecoration(
        color: _colorOf(color),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))
        ],
      ),
    );
  }

  Color _colorOf(LudoColor c) {
    switch (c) {
      case LudoColor.red:
        return const Color(0xFFE74C3C);
      case LudoColor.green:
        return const Color(0xFF27AE60);
      case LudoColor.yellow:
        return const Color(0xFFF1C40F);
      case LudoColor.blue:
        return const Color(0xFF2980B9);
    }
  }
}

/// Player colors used on board and tokens.
enum LudoColor { red, green, yellow, blue }

/// The painter draws the board background (no tokens)
class _LudoPainter extends CustomPainter {
  static const int n = 15; // 15x15 grid
  final ui.Image? background;
  final bool showGrid;
  final Map<LudoColor, List<Cell>> tokens; // unused here when passed {}
  final List<Cell> highlightCells;
  final bool showCellLabels;

  _LudoPainter({
    required this.background,
    required this.showGrid,
    required this.tokens,
    required this.highlightCells,
    required this.showCellLabels
  });

  final Color red = const Color(0xFFE74C3C);
  final Color green = const Color(0xFF27AE60);
  final Color yellow = const Color(0xFFF1C40F);
  final Color blue = const Color(0xFF2980B9);
  final Color line = const Color(0xFF222222).withOpacity(0.7);

  @override
bool shouldRepaint(covariant _LudoPainter oldDelegate) {
  return showGrid != oldDelegate.showGrid ||
         highlightCells != oldDelegate.highlightCells ||
         showCellLabels != oldDelegate.showCellLabels ||
         background != oldDelegate.background; // 👈 add this
}

@override
void paint(Canvas canvas, Size size) {
  final double cell = size.width / n;
  final rect = Offset.zero & size;

   

  // === 1. Background ===
  final bgPaint = Paint()..color = Colors.white;
  canvas.drawRect(rect, bgPaint);

  //=== 2. Quadrants ===
  final redPaint = Paint()..color = Colors.red.shade300;
  final greenPaint = Paint()..color = Colors.green.shade300;
  final yellowPaint = Paint()..color = Colors.yellow.shade300;
  final bluePaint = Paint()..color = Colors.blue.shade300;

  canvas.drawRect(Rect.fromLTWH(0, 0, 6 * cell, 6 * cell), redPaint); // top-left
  canvas.drawRect(Rect.fromLTWH(9 * cell, 0, 6 * cell, 6 * cell), greenPaint); // top-right
  canvas.drawRect(Rect.fromLTWH(0, 9 * cell, 6 * cell, 6 * cell), yellowPaint); // bottom-left
  canvas.drawRect(Rect.fromLTWH(9 * cell, 9 * cell, 6 * cell, 6 * cell), bluePaint); // bottom-right

  // === 3. Cross paths ===
  final whitePaint = Paint()..color = Colors.white;
  canvas.drawRect(Rect.fromLTWH(6 * cell, 0, 3 * cell, 15 * cell), whitePaint); // vertical bar
  canvas.drawRect(Rect.fromLTWH(0, 6 * cell, 15 * cell, 3 * cell), whitePaint); // horizontal bar

  // colored paths
  canvas.drawRect(Rect.fromLTWH(7 * cell, 1 * cell, 1 * cell, 5 * cell), greenPaint);
  canvas.drawRect(Rect.fromLTWH(1 * cell, 7 * cell, 5 * cell, 1 * cell), redPaint);
  canvas.drawRect(Rect.fromLTWH(9 * cell, 7 * cell, 5 * cell, 1 * cell), bluePaint);
  canvas.drawRect(Rect.fromLTWH(7 * cell, 9 * cell, 1 * cell, 5 * cell), yellowPaint);
  //Entry point places
  canvas.drawRect(Rect.fromLTWH(8 * cell, 1 * cell, 1 * cell, 1 * cell), greenPaint);
  canvas.drawRect(Rect.fromLTWH(1 * cell, 6 * cell, 1 * cell, 1 * cell), redPaint);
  canvas.drawRect(Rect.fromLTWH(13 * cell, 8 * cell, 1 * cell, 1 * cell), bluePaint);
  canvas.drawRect(Rect.fromLTWH(6 * cell, 13 * cell, 1 * cell, 1 * cell), yellowPaint);

  

  // === 4. Center triangles ===
  final path = Path();

  // red
  path.moveTo(6 * cell, 6 * cell);
  path.lineTo(9 * cell, 6 * cell);
  path.lineTo(7.5 * cell, 7.5 * cell);
  path.close();
  canvas.drawPath(path, greenPaint);

  // green
  path.reset();
  path.moveTo(9 * cell, 6 * cell);
  path.lineTo(9 * cell, 9 * cell);
  path.lineTo(7.5 * cell, 7.5 * cell);
  path.close();
  canvas.drawPath(path, bluePaint);

  // blue
  path.reset();
  path.moveTo(9 * cell, 9 * cell);
  path.lineTo(6 * cell, 9 * cell);
  path.lineTo(7.5 * cell, 7.5 * cell);
  path.close();
  canvas.drawPath(path, yellowPaint);

  // yellow
  path.reset();
  path.moveTo(6 * cell, 9 * cell);
  path.lineTo(6 * cell, 6 * cell);
  path.lineTo(7.5 * cell, 7.5 * cell);
  path.close();
  canvas.drawPath(path, redPaint);

  

  

  // === 6. Grid lines ===
  if (showGrid) {
    final gridPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (int i = 0; i <= n; i++) {
      canvas.drawLine(Offset(i * cell, 0), Offset(i * cell, size.height), gridPaint);
      canvas.drawLine(Offset(0, i * cell), Offset(size.width, i * cell), gridPaint);
    }

    //darker outlines
final darkline = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      //verticle lines
    canvas.drawLine(Offset(6 * cell, 0), Offset(6 * cell, size.height), darkline);
    canvas.drawLine(Offset(9 * cell, 0), Offset(9 * cell, size.height), darkline);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), darkline);
    canvas.drawLine(Offset(15*cell, 0), Offset(15*cell, size.height), darkline);
    //horizontal lines
    canvas.drawLine(Offset(0, 6 * cell), Offset(size.width, 6 * cell), darkline);
    canvas.drawLine(Offset(0, 9 * cell), Offset(size.width, 9 * cell), darkline);
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), darkline);
    canvas.drawLine(Offset(0, 15 * cell), Offset(size.width, 15 * cell), darkline);

    //Player Home Lines
    //Red Player
    canvas.drawLine(Offset(2*cell, 7*cell), Offset(6*cell, 7*cell), darkline);
    canvas.drawLine(Offset(1*cell, 8*cell), Offset(6*cell, 8*cell), darkline);
    canvas.drawLine(Offset(1*cell, 8*cell), Offset(1*cell, 6*cell), darkline);
    canvas.drawLine(Offset(2*cell, 7*cell), Offset(2*cell, 6*cell), darkline);
    //Green Player
    canvas.drawLine(Offset(7*cell, 1*cell), Offset(9*cell, 1*cell), darkline);
    canvas.drawLine(Offset(8*cell, 2*cell), Offset(9*cell, 2*cell), darkline);
    canvas.drawLine(Offset(7*cell, 1*cell), Offset(7*cell, 6*cell), darkline);
    canvas.drawLine(Offset(8*cell, 2*cell), Offset(8*cell, 6*cell), darkline);
    //blue Player
    canvas.drawLine(Offset(14*cell, 7*cell), Offset(9*cell, 7*cell), darkline);
    canvas.drawLine(Offset(13*cell, 8*cell), Offset(9*cell, 8*cell), darkline);
    canvas.drawLine(Offset(14*cell, 7*cell), Offset(14*cell, 9*cell), darkline);
    canvas.drawLine(Offset(13*cell, 8*cell), Offset(13*cell, 9*cell), darkline);
     //yellow Player
    canvas.drawLine(Offset(8*cell, 9*cell), Offset(8*cell, 14*cell), darkline);
    canvas.drawLine(Offset(7*cell, 9*cell), Offset(7*cell, 13*cell), darkline);
    canvas.drawLine(Offset(6*cell, 13*cell), Offset(7*cell, 13*cell), darkline);
    canvas.drawLine(Offset(6*cell, 14*cell), Offset(8*cell, 14*cell), darkline);

    

    _drawStar(canvas, cell, const Cell(8,2), color: Colors.black);
    _drawStar(canvas, cell, const Cell(2,6), color: Colors.black);
    _drawStar(canvas, cell, const Cell(12,8), color: Colors.black);
    _drawStar(canvas, cell, const Cell(6,12), color: Colors.black);

     
  }

  

 // === 7. Highlight cells ===
  final highlightPaint = Paint()
    ..color = Colors.purple.withOpacity(0.3)
    ..style = PaintingStyle.fill;
  for (var c in highlightCells) {
    canvas.drawRect(
      Rect.fromLTWH(c.c * cell, c.r * cell, cell, cell),
      highlightPaint,
    );
  }

  //=== 8. Debug cell labels ===
  if (showCellLabels) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        final Rect cellRect = Rect.fromLTWH(c * cell, r * cell, cell, cell);
        textPainter.text = TextSpan(
          text: "$r,$c",
          style: const TextStyle(fontSize: 7, color: Colors.black),
        );
        textPainter.layout(minWidth: 0, maxWidth: cell);
        textPainter.paint(
          canvas,
          Offset(
            cellRect.left + (cell - textPainter.width) / 2,
            cellRect.top + (cell - textPainter.height) / 2,
          ),
        );
      }
    }
  }

  if (background != null) {
    // Scale image to fit board size
    final paint = Paint();
    final src = Rect.fromLTWH(12, 12, background!.width.toDouble()*0.975, background!.height.toDouble()*0.969);
    final dst = Rect.fromLTWH(
    0,
    0,
    size.width,
    size.height,
  );
    canvas.drawImageRect(background!, src, dst, paint);
  } else {
    // fallback white background
    canvas.drawRect(rect, Paint()..color = Colors.transparent);
  }
}




  void _drawCenterTriangles(Canvas canvas, double cell) {
    final double s = cell;
    final Rect center = Rect.fromLTWH(6 * s, 6 * s, 3 * s, 3 * s);
    canvas.drawRect(center, Paint()..color = Colors.white);

    final Path redTri = Path()
      ..moveTo(center.left, center.center.dy)
      ..lineTo(center.center.dx, center.top)
      ..lineTo(center.center.dx, center.bottom)
      ..close();
    final Path greenTri = Path()
      ..moveTo(center.right, center.center.dy)
      ..lineTo(center.center.dx, center.top)
      ..lineTo(center.center.dx, center.bottom)
      ..close();
    final Path yellowTri = Path()
      ..moveTo(center.center.dx, center.bottom)
      ..lineTo(center.left, center.center.dy)
      ..lineTo(center.right, center.center.dy)
      ..close();
    final Path blueTri = Path()
      ..moveTo(center.center.dx, center.top)
      ..lineTo(center.left, center.center.dy)
      ..lineTo(center.right, center.center.dy)
      ..close();

    canvas.drawPath(redTri, Paint()..color = red.withAlpha(55));
    canvas.drawPath(greenTri, Paint()..color = green.withAlpha(55));
    canvas.drawPath(yellowTri, Paint()..color = yellow.withAlpha(55));
    canvas.drawPath(blueTri, Paint()..color = blue.withAlpha(55));

    canvas.drawRect(
      center,
      Paint()
        ..color = Colors.black.withOpacity(.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

void _drawStar(Canvas canvas, double cell, Cell pos, {Color color = Colors.black}) {
  final double cx = (pos.c + 0.5) * cell; // center X
  final double cy = (pos.r + 0.5) * cell; // center Y
  final double outerRadius = cell * 0.4;   // star outer radius
  final double innerRadius = cell * 0.18;  // star inner radius

  final Path path = Path();
  const int points = 5;
  for (int i = 0; i < points * 2; i++) {
    final double angle = (i * 3.14159265 / points) - 3.14159265 / 2; // rotate to top
    final double radius = (i.isEven ? outerRadius : innerRadius);
    final double x = cx + radius * Math.cos(angle);
    final double y = cy + radius * Math.sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();

  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  canvas.drawPath(path, paint);
}

  void _drawSafeDot(Canvas canvas, double cell, Cell pos) {
    final Offset center = Offset((pos.c + .5) * cell, (pos.r + .5) * cell);
    canvas.drawCircle(center, cell * .12, Paint()..color = Colors.black.withOpacity(.35));
  }

  void _drawYardBorder(Canvas canvas, double cell, {required int baseRow, required int baseCol, required Color color}) {
    final Rect yardRect = Rect.fromLTWH(baseCol * cell, baseRow * cell, 6 * cell, 6 * cell);
    canvas.drawRRect(
      RRect.fromRectAndRadius(yardRect, Radius.circular(cell * .2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = color.withOpacity(.6),
    );
  }

  // Helpers
  Iterable<Rect> _cellsRect(int startRow, int startCol, int rows, int cols) sync* {
    for (int r = startRow; r < startRow + rows; r++) {
      for (int c = startCol; c < startCol + cols; c++) {
        yield Rect.fromLTWH(c.toDouble(), r.toDouble(), 1, 1);
      }
    }
  }

  Iterable<Rect> _cellsRow(int row, int startCol, int len) sync* {
    for (int c = startCol; c < startCol + len; c++) {
      yield Rect.fromLTWH(c.toDouble(), row.toDouble(), 1, 1);
    }
  }

  Iterable<Rect> _cellsCol(int startRow, int col, int len) sync* {
    for (int r = startRow; r < startRow + len; r++) {
      yield Rect.fromLTWH(col.toDouble(), r.toDouble(), 1, 1);
    }
  }

  void _fillCells(Canvas canvas, double cell, Iterable<Rect> cells, Color color) {
    final Paint p = Paint()..color = color;
    for (final unit in cells) {
      final Rect r = Rect.fromLTWH(unit.left * cell, unit.top * cell, cell, cell);
      canvas.drawRect(r, p);
    }
  }

// @override
// bool shouldRepaint(covariant _LudoPainter oldDelegate) {
//   return showGrid != oldDelegate.showGrid ||
//          highlightCells != oldDelegate.highlightCells ||
//          showCellLabels != oldDelegate.showCellLabels; // ✅ add this
// }

}
