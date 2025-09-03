import 'package:flutter/material.dart';

/// Simple, scalable Ludo board with optional tokens.
/// Grid is 15x15 cells. Provide token positions in (row, col) [0..14].
class LudoBoard extends StatelessWidget {
  const LudoBoard({
    super.key,
    this.size = 360,
    this.showGrid = true,
    this.tokens = const {},
    this.highlightCells = const <Cell>[],
  });

  /// The board is square; size is width/height in logical pixels.
  final double size;

  /// Show 15x15 grid overlay.
  final bool showGrid;

  /// Map of player color to a list of token cell positions.
  /// Example: {LudoColor.red: [Cell(1,1), Cell(2,2)]}
  final Map<LudoColor, List<Cell>> tokens;

  /// Optional highlighted cells (e.g., valid moves).
  final List<Cell> highlightCells;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size.square(size),
        painter: _LudoPainter(
          showGrid: showGrid,
          tokens: tokens,
          highlightCells: highlightCells,
        ),
      ),
    );
  }
}

/// Player colors used on board and tokens.
enum LudoColor { red, green, yellow, blue }

/// Integer cell position (row, col) on a 15x15 board.
class Cell {
  final int r;
  final int c;
  const Cell(this.r, this.c);
}

class _LudoPainter extends CustomPainter {
  static const int n = 15; // 15x15 grid

  final bool showGrid;
  final Map<LudoColor, List<Cell>> tokens;
  final List<Cell> highlightCells;

  _LudoPainter({
    required this.showGrid,
    required this.tokens,
    required this.highlightCells,
  });

  // Theme colors (feel free to tweak shades)
  final Color red = const Color(0xFFE74C3C);
  final Color green = const Color(0xFF27AE60);
  final Color yellow = const Color(0xFFF1C40F);
  final Color blue = const Color(0xFF2980B9);
  final Color line = const Color(0xFF222222).withOpacity(0.7);

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / n;
    final rect = Offset.zero & size;

    // Background
    final bg = Paint()..color = Colors.white;
    canvas.drawRect(rect, bg);

    // Quadrant squares (6x6 each)
    _fillCells(canvas, cell, _cellsRect(0, 0, 6, 6), red.withAlpha(80));
    _fillCells(canvas, cell, _cellsRect(0, 9, 6, 6), green.withAlpha(80));
    _fillCells(canvas, cell, _cellsRect(9, 0, 6, 6), yellow.withAlpha(80));
    _fillCells(canvas, cell, _cellsRect(9, 9, 6, 6), blue.withAlpha(80));

    // Cross arms (3 cells thick)
    _fillCells(canvas, cell, _cellsRect(6, 0, 3, 15), Colors.white); // horizontal
    _fillCells(canvas, cell, _cellsRect(0, 6, 15, 3), Colors.white); // vertical

    // Home rows coloring (5 cells from each side towards center)
    // Using conventional layout:
    // Red: left -> center along row 7
   // Correct home rows
// Red: (row 7, col 1..5)
_fillCells(canvas, cell, _cellsRow(7, 1, 5), red.withAlpha(80));
_fillCells(canvas, cell, _cellsRow(6, 1, 1), red.withAlpha(80));
// Green: (row 7, col 9..13)
_fillCells(canvas, cell, _cellsRow(7, 9, 5), blue.withAlpha(80));
_fillCells(canvas, cell, _cellsRow(8, 13, 1), blue.withAlpha(80));
// Yellow: (row 9..13, col 7)
_fillCells(canvas, cell, _cellsCol(9, 7, 5), yellow.withAlpha(80));
_fillCells(canvas, cell, _cellsCol(13, 6, 1), yellow.withAlpha(80));
// Blue: (row 1..5, col 7)
_fillCells(canvas, cell, _cellsCol(1, 7, 5), green.withAlpha(80));
_fillCells(canvas, cell, _cellsCol(1, 8, 1), green.withAlpha(80));


    // Center 3x3 with four triangles pointing in
    _drawCenterTriangles(canvas, cell);

    // Optional safe cells (entry to each color path) – draw small dots
    final safeCells = <Cell>[
      const Cell(7, 6), // left entry to center lane
      const Cell(7, 8), // right entry
      const Cell(6, 7), // top entry
      const Cell(8, 7), // bottom entry
      // Additional classic safe spots at each arm (adjust as you like):
      const Cell(1, 7), const Cell(7, 13),
      const Cell(13, 7), const Cell(7, 1),
    ];
    for (final s in safeCells) {
      _drawSafeDot(canvas, cell, s);
    }

    // Starting "yard" circles (4 per corner)
    _drawYardTokens(canvas, cell, LudoColor.red, baseRow: 0, baseCol: 0);
    _drawYardTokens(canvas, cell, LudoColor.green, baseRow: 0, baseCol: 9);
    _drawYardTokens(canvas, cell, LudoColor.yellow, baseRow: 9, baseCol: 0);
    _drawYardTokens(canvas, cell, LudoColor.blue, baseRow: 9, baseCol: 9);

    // Highlight cells (e.g., valid moves)
    for (final h in highlightCells) {
      final r = Rect.fromLTWH(h.c * cell, h.r * cell, cell, cell);
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.black.withOpacity(.5);
      canvas.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(cell * .15)), p);
    }

    // Player tokens
    tokens.forEach((color, cells) {
      for (final pos in cells) {
        _drawToken(canvas, cell, pos, _colorOf(color));
      }
    });

    // Grid lines
    if (showGrid) {
      final grid = Paint()
        ..color = line.withOpacity(.3)
        ..strokeWidth = 1;
      for (int i = 0; i <= n; i++) {
        final d = i * cell;
        canvas.drawLine(Offset(0, d), Offset(size.width, d), grid);
        canvas.drawLine(Offset(d, 0), Offset(d, size.width), grid);
      }
    }

    // Outer border
    final border = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, border);
  }

  void _drawCenterTriangles(Canvas canvas, double cell) {
    // Center area rows/cols 6..8
    final double s = cell;
    final Rect center = Rect.fromLTWH(6 * s, 6 * s, 3 * s, 3 * s);

    // Draw white base
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

    // Center diamond outline
    canvas.drawRect(
      center,
      Paint()
        ..color = Colors.black.withOpacity(.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  // Draw 4 faint token spots in a 2x2 layout inside a 6x6 yard
  void _drawYardTokens(Canvas canvas, double cell, LudoColor who,
      {required int baseRow, required int baseCol}) {
    final Color col = _colorOf(who).withOpacity(.35);
    final Paint p = Paint()..color = col;
    final double r = cell * 0.35;

    final List<Cell> pads = [
      Cell(baseRow + 1, baseCol + 1),
      Cell(baseRow + 1, baseCol + 4),
      Cell(baseRow + 4, baseCol + 1),
      Cell(baseRow + 4, baseCol + 4),
    ];
    for (final pad in pads) {
      final Offset center = Offset((pad.c + .5) * cell, (pad.r + .5) * cell);
      canvas.drawCircle(center, r, p);
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.black.withOpacity(.25),
      );
    }

    // Yard border
    final Rect yardRect = Rect.fromLTWH(baseCol * cell, baseRow * cell, 6 * cell, 6 * cell);
    canvas.drawRRect(
      RRect.fromRectAndRadius(yardRect, Radius.circular(cell * .2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = _colorOf(who).withOpacity(.6),
    );
  }

  void _drawToken(Canvas canvas, double cell, Cell pos, Color color) {
    final Offset center = Offset((pos.c + .5) * cell, (pos.r + .5) * cell);
    final double R = cell * .42;
    final Paint fill = Paint()..color = color;
    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white;

    canvas.drawCircle(center, R, fill);
    canvas.drawCircle(center, R, ring);

    // Small shine
    canvas.drawCircle(center.translate(-R * .3, -R * .3), R * .25, Paint()..color = Colors.white.withOpacity(.5));
  }

  void _drawSafeDot(Canvas canvas, double cell, Cell pos) {
    final Offset center = Offset((pos.c + .5) * cell, (pos.r + .5) * cell);
    canvas.drawCircle(center, cell * .12, Paint()..color = Colors.black.withOpacity(.35));
  }

  // Helpers to create cell rectangles
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

  Color _colorOf(LudoColor c) {
    switch (c) {
      case LudoColor.red:
        return red;
      case LudoColor.green:
        return green;
      case LudoColor.yellow:
        return yellow;
      case LudoColor.blue:
        return blue;
    }
  }

  @override
  bool shouldRepaint(covariant _LudoPainter oldDelegate) {
    return showGrid != oldDelegate.showGrid ||
        tokens != oldDelegate.tokens ||
        highlightCells != oldDelegate.highlightCells;
  }
}
