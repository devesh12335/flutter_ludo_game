class Cell {
  final int r;
  final int c;
  const Cell(this.r, this.c);

  @override
  bool operator ==(Object other) =>
      other is Cell && other.r == r && other.c == c;

  @override
  int get hashCode => r * 31 + c;

  @override
  String toString() => 'Cell($r,$c)';
}
