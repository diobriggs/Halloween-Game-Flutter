import 'dart:math'; // For random movement
import 'package:flutter/material.dart';

void main() {
  runApp(SpookyGameApp());
}

class SpookyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Game',
      theme: ThemeData.dark(),
      home: SpookyGameScreen(),
    );
  }
}

class SpookyGameScreen extends StatefulWidget {
  @override
  _SpookyGameScreenState createState() => _SpookyGameScreenState();
}

class _SpookyGameScreenState extends State<SpookyGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _ghostController;
  late AnimationController _batsController;
  late Animation<double> _ghostAnimation;
  late Animation<double> _batsAnimation;
  Random random = Random();

  @override
  void initState() {
    super.initState();

    // Animation Controller for Ghost (floating up and down)
    _ghostController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _ghostAnimation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _ghostController, curve: Curves.easeInOut),
    );

    // Animation Controller for Bats (moving left to right randomly)
    _batsController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _batsAnimation = Tween<double>(begin: -50, end: 50).animate(
      CurvedAnimation(parent: _batsController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ghostController.dispose();
    _batsController.dispose();
    super.dispose();
  }

  // Function to show the trap alert dialog
  void _showTrapDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("It's a Trap!"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Animated Ghost (Floating effect)
          AnimatedBuilder(
            animation: _ghostController,
            builder: (context, child) {
              return Positioned(
                top: 100 + _ghostAnimation.value,
                left: 50,
                child: GestureDetector(
                  onTap: () {
                    _showTrapDialog(context, "You encountered a spooky ghost!");
                  },
                  child: Image.asset(
                    'assets/ghost.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              );
            },
          ),

          // Pumpkin (Safe)
          Positioned(
            bottom: 100,
            right: 50,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pumpkin is safe!")),
                );
              },
              child: Image.asset(
                'assets/pumpkin.png',
                width: 100,
                height: 100,
              ),
            ),
          ),

          // Animated Bats (Random left-to-right movement)
          AnimatedBuilder(
            animation: _batsController,
            builder: (context, child) {
              return Positioned(
                top: 200,
                right: 50 + _batsAnimation.value,
                child: GestureDetector(
                  onTap: () {
                    _showTrapDialog(context, "You got caught by the bats!");
                  },
                  child: Image.asset(
                    'assets/bats.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              );
            },
          ),

          // Candy (Trap)
          Positioned(
            bottom: 200,
            left: 50,
            child: GestureDetector(
              onTap: () {
                _showTrapDialog(context, "Beware! The candy is a trick!");
              },
              child: Image.asset(
                'assets/candy.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
