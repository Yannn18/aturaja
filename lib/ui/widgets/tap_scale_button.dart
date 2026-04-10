import 'package:flutter/material.dart';

class TapScaleButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const TapScaleButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  State<TapScaleButton> createState() => _TapScaleButtonState();
}

class _TapScaleButtonState extends State<TapScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.02,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.98).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnim, child: widget.child),
    );
  }
}