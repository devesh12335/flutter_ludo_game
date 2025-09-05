import 'dart:math';
import 'package:flutter/material.dart';

enum LudoPlayer { red, green, yellow, blue }

class AnimatedDice extends StatefulWidget {
  final LudoPlayer player;
  final void Function(int value, LudoPlayer player)? onRolled;

  const AnimatedDice({super.key, required this.player, this.onRolled});

  @override
  State<AnimatedDice> createState() => _AnimatedDiceState();
}

class _AnimatedDiceState extends State<AnimatedDice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentValue = 1;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  void _rollDice() {
    setState(() {
      _currentValue = _rand.nextInt(6) + 1;
    });
    widget.onRolled?.call(_currentValue, widget.player);
    _controller.forward();
  }

  Color _playerColor() {
    switch (widget.player) {
      case LudoPlayer.red:
        return Colors.red;
      case LudoPlayer.green:
        return Colors.green;
      case LudoPlayer.yellow:
        return Colors.yellow.shade700;
      case LudoPlayer.blue:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_animation),
          child: InkWell(
            onTap: _rollDice,
            child: DiceFace(value: _currentValue, color: _playerColor()),
          ),
        ),
        const SizedBox(height: 10),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: _playerColor(),
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        //   ),
        //   onPressed: _rollDice,
        //   child: Text(
        //     "Roll (${widget.player.name.toUpperCase()})",
        //     style: const TextStyle(color: Colors.white),
        //   ),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Dice face painter widget (1–6 pips)
class DiceFace extends StatelessWidget {
  final int value;
  final Color color;
  const DiceFace({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: this.color,
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 2)),
        ],
      ),
      child: CustomPaint(painter: _DicePainter(value)),
    );
  }
}

class _DicePainter extends CustomPainter {
  final int value;
  _DicePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    double r = size.width * 0.08;

    void dot(double x, double y) {
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final cx = size.width / 2;
    final cy = size.height / 2;
    final offset = size.width * 0.25;

    switch (value) {
      case 1:
        dot(cx, cy);
        break;
      case 2:
        dot(cx - offset, cy - offset);
        dot(cx + offset, cy + offset);
        break;
      case 3:
        dot(cx, cy);
        dot(cx - offset, cy - offset);
        dot(cx + offset, cy + offset);
        break;
      case 4:
        dot(cx - offset, cy - offset);
        dot(cx + offset, cy - offset);
        dot(cx - offset, cy + offset);
        dot(cx + offset, cy + offset);
        break;
      case 5:
        dot(cx, cy);
        dot(cx - offset, cy - offset);
        dot(cx + offset, cy - offset);
        dot(cx - offset, cy + offset);
        dot(cx + offset, cy + offset);
        break;
      case 6:
        dot(cx - offset, cy - offset);
        dot(cx, cy - offset);
        dot(cx + offset, cy - offset);
        dot(cx - offset, cy + offset);
        dot(cx, cy + offset);
        dot(cx + offset, cy + offset);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _DicePainter oldDelegate) =>
      oldDelegate.value != value;
}
