import 'package:flutter/material.dart';

class HeartAnimation extends StatefulWidget {
  final Offset startPosition;
  final VoidCallback onComplete;

  const HeartAnimation({
    required Key key,
    required this.startPosition,
    required this.onComplete,
  }) : super(key: key);

  @override
  HeartAnimationState createState() => HeartAnimationState();
}

class HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: widget.startPosition.dy,
      end: widget.startPosition.dy - 256,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.startPosition.dx - 15, // Center the heart
          top: _animation.value,
          child: const Icon(
            Icons.favorite,
            color: Colors.red,
            size: 32,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}