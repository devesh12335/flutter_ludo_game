import 'package:flutter/material.dart';
import 'package:ludo_game/models/cell.dart';

/// Simple Ludo board that paints the board and places tappable token widgets
/// on top. Call [onTokenTap] to notify parent which player/color and which
/// token index was tapped.
class LudoBoard extends StatelessWidget {
  const LudoBoard({
    super.key,
    this.size = 360,
    this.showGrid = true,
    this.tokens = const {},
    this.highlightCells = const <Cell>[],
    this.onTokenTap,
  });

  final double size;
  final bool showGrid;
  final Map<LudoColor, List<Cell>> tokens;
  final List<Cell> highlightCells;

  /// Called when a token is tapped: color + tokenIndex (0..3)
  final void Function(LudoColor color, int tokenIndex)? onTokenTap;

  @override
  Widget build(BuildContext context) {
    // cell size in logical pixels
    final double cell = size / _LudoPainter.n;
    final double tokenSize = cell * 0.72;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Board background painted (we pass empty tokens to painter to avoid duplicates)
        CustomPaint(
  size: Size.square(size),
  painter: _LudoPainter(
    showGrid: showGrid,
    tokens: const {},
    highlightCells: highlightCells,
    showCellLabels: true, // ✅ toggle here
  ),
),


          // Tappable token widgets
          // We use the tokens map that parent/controller supplies as Cell positions.
          ...tokens.entries.expand((entry) {
            final LudoColor color = entry.key;
            final List<Cell> cellList = entry.value;

            return List.generate(cellList.length, (i) {
              final Cell pos = cellList[i];

              // position token centered in the grid cell
              final double left = pos.c * cell + (cell - tokenSize) / 2;
              final double top = pos.r * cell + (cell - tokenSize) / 2;

              return Positioned(
                left: left,
                top: top,
                width: tokenSize,
                height: tokenSize,
                child: GestureDetector(
                  onTap: () {
                    onTokenTap?.call(color, i);
                  },
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
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          color: _colorOf(color),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1,1))],
        ),
      );
    });
  }

  // Local color helper (was previously inside painter)
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

  final bool showGrid;
  final Map<LudoColor, List<Cell>> tokens; // unused here when passed {}
  final List<Cell> highlightCells;
  final bool showCellLabels;

  _LudoPainter({
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
void paint(Canvas canvas, Size size) {
  final double cellSize = size.width / n;
  final rect = Offset.zero & size;

  // === 🎨 Board background ===
  final bgPaint = Paint()..color = Colors.white;
  canvas.drawRect(rect, bgPaint);

  // === 🎨 Quadrants (Red, Green, Yellow, Blue) ===
  final redPaint = Paint()..color = Colors.red.shade300;
  final greenPaint = Paint()..color = Colors.green.shade300;
  final yellowPaint = Paint()..color = Colors.yellow.shade300;
  final bluePaint = Paint()..color = Colors.blue.shade300;

  canvas.drawRect(Rect.fromLTWH(0, 0, 6 * cellSize, 6 * cellSize), redPaint); // top-left
  canvas.drawRect(Rect.fromLTWH(9 * cellSize, 0, 6 * cellSize, 6 * cellSize), greenPaint); // top-right
  canvas.drawRect(Rect.fromLTWH(0, 9 * cellSize, 6 * cellSize, 6 * cellSize), yellowPaint); // bottom-left
  canvas.drawRect(Rect.fromLTWH(9 * cellSize, 9 * cellSize, 6 * cellSize, 6 * cellSize), bluePaint); // bottom-right

  // === 🎨 Middle cross (white center + colored home paths) ===
  final whitePaint = Paint()..color = Colors.white;
  canvas.drawRect(Rect.fromLTWH(6 * cellSize, 0, 3 * cellSize, 15 * cellSize), whitePaint); // vertical bar
  canvas.drawRect(Rect.fromLTWH(0, 6 * cellSize, 15 * cellSize, 3 * cellSize), whitePaint); // horizontal bar

  // Home path colors
  canvas.drawRect(Rect.fromLTWH(6 * cellSize, 1 * cellSize, 3 * cellSize, 5 * cellSize), greenPaint); // green path
  canvas.drawRect(Rect.fromLTWH(1 * cellSize, 6 * cellSize, 5 * cellSize, 3 * cellSize), redPaint);   // red path
  canvas.drawRect(Rect.fromLTWH(9 * cellSize, 6 * cellSize, 5 * cellSize, 3 * cellSize), bluePaint);  // blue path
  canvas.drawRect(Rect.fromLTWH(6 * cellSize, 9 * cellSize, 3 * cellSize, 5 * cellSize), yellowPaint);// yellow path

  // === 🎯 Safe center triangle ===
  final path = Path()
    ..moveTo(6 * cellSize, 6 * cellSize)
    ..lineTo(9 * cellSize, 6 * cellSize)
    ..lineTo(7.5 * cellSize, 7.5 * cellSize)
    ..close();
  canvas.drawPath(path, redPaint);

path.reset();
  path
    ..moveTo(9 * cellSize, 6 * cellSize)
    ..lineTo(9 * cellSize, 9 * cellSize)
    ..lineTo(7.5 * cellSize, 7.5 * cellSize)
    ..close();
  canvas.drawPath(path, greenPaint);

path.reset();
  path
    ..moveTo(9 * cellSize, 9 * cellSize)
    ..lineTo(6 * cellSize, 9 * cellSize)
    ..lineTo(7.5 * cellSize, 7.5 * cellSize)
    ..close();
  canvas.drawPath(path, bluePaint);

path.reset();
  path
    ..moveTo(6 * cellSize, 9 * cellSize)
    ..lineTo(6 * cellSize, 6 * cellSize)
    ..lineTo(7.5 * cellSize, 7.5 * cellSize)
    ..close();
  canvas.drawPath(path, yellowPaint);

  // === 🟢 Safe dots (4 per quadrant) ===
  final dotPaint = Paint()..color = Colors.black;
  const offsets = [
    Offset(2, 2), Offset(4, 2), Offset(2, 4), Offset(4, 4), // Red
    Offset(10, 2), Offset(12, 2), Offset(10, 4), Offset(12, 4), // Green
    Offset(2, 10), Offset(4, 10), Offset(2, 12), Offset(4, 12), // Yellow
    Offset(10, 10), Offset(12, 10), Offset(10, 12), Offset(12, 12), // Blue
  ];
  for (var o in offsets) {
    canvas.drawCircle(Offset(o.dx * cellSize, o.dy * cellSize), cellSize / 5, dotPaint);
  }

  // === 📏 Grid lines ===
  if (showGrid) {
    final gridPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (int i = 0; i <= n; i++) {
      // vertical
      canvas.drawLine(Offset(i * cellSize, 0), Offset(i * cellSize, size.height), gridPaint);
      // horizontal
      canvas.drawLine(Offset(0, i * cellSize), Offset(size.width, i * cellSize), gridPaint);
    }
  }

  // === 🧩 Highlight cells ===
  final highlightPaint = Paint()
    ..color = Colors.purple.withOpacity(0.3)
    ..style = PaintingStyle.fill;
  for (var cell in highlightCells) {
  final row = cell.r;
  final col = cell.c;
  canvas.drawRect(
    Rect.fromLTWH(col * cellSize, row * cellSize, cellSize, cellSize),
    highlightPaint,
  );
}


  // === 🔢 Cell coordinates (on top for debugging) ===
  if (showCellLabels) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        final Rect cellRect = Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize);
        textPainter.text = TextSpan(
          text: "$r,$c",
          style: const TextStyle(fontSize: 7, color: Colors.black),
        );
        textPainter.layout(minWidth: 0, maxWidth: cellSize);
        textPainter.paint(
          canvas,
          Offset(
            cellRect.left + (cellSize - textPainter.width) / 2,
            cellRect.top + (cellSize - textPainter.height) / 2,
          ),
        );
      }
    }
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

    canvas.drawPath(redTri, Paint()..color = red.withOpacity(.55));
    canvas.drawPath(greenTri, Paint()..color = green.withOpacity(.55));
    canvas.drawPath(yellowTri, Paint()..color = yellow.withOpacity(.55));
    canvas.drawPath(blueTri, Paint()..color = blue.withOpacity(.55));

    canvas.drawRect(
      center,
      Paint()
        ..color = Colors.black.withOpacity(.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
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

@override
bool shouldRepaint(covariant _LudoPainter oldDelegate) {
  return showGrid != oldDelegate.showGrid ||
         highlightCells != oldDelegate.highlightCells ||
         showCellLabels != oldDelegate.showCellLabels; // ✅ add this
}

}
