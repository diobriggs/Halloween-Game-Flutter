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

class SpookyGameScreen extends StatelessWidget {
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
          
          // Ghost (Trap)
          Positioned(
            top: 100,
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
          ),

          // Pumpkin (Safe)
          Positioned(
            bottom: 100,
            right: 50,
            child: GestureDetector(
              onTap: () {
                // Pumpkin is safe
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

          // Bats (Trap)
          Positioned(
            top: 200,
            right: 50,
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
