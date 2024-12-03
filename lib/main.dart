import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:novosadster/heart_animation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> 
  final controller = ConfettiController();
  final random = Random();

  List<Widget> hearts = [];

  var isPressed = false;
  var points = 0;

  @override
  void initState() {
    super.initState();
    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = (isPressed ? 248 : 256) - points * 2;

    if (size < 0) {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          const Scaffold(
              body: Center(
                child: Text("You won!",
                    style: TextStyle(color: Colors.white, fontSize: 48)),
              )),
          ConfettiWidget(
            confettiController: controller,
            shouldLoop: true,
            blastDirection: pi / 2,
            numberOfParticles: 10,
            emissionFrequency: 0.1,
            gravity: 0.1,
            blastDirectionality: BlastDirectionality.explosive,
            colors: const [Colors.blue, Colors.yellow],
          )
        ],
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(
                    "Points: $points",
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            isPressed = true;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            isPressed = false;
                            points -= 2;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(128),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(128),
                            child: Image.asset(
                              'assets/avatar.jpg',
                              width: 256,
                              height: 256,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "Tap the techer!",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ...hearts,
          ],
        ),
      ),
    );
  }

  void _addHeart(TapUpDetails details) {
    final tapPosition = details.globalPosition +
        Offset(random.nextDouble() * 64, -(random.nextDouble() * 64));
    final key = UniqueKey();
    setState(() {
      hearts.add(HeartAnimation(
        key: key,
        startPosition: tapPosition,
        onComplete: () {
          setState(() {
            hearts.removeWhere((heart) => heart.key == key);
          });
        },
      ));
    });
  }
}
