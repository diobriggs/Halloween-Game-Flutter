import 'dart:math'; // For random movement
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // For audio playback

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
  late AudioPlayer _audioPlayer; // For background music
  late AudioPlayer _trapPlayer; // For trap sound
  late AudioPlayer _successPlayer; // For success sound

  bool hasWon = false; // To track if the player has won

  @override
  void initState() {
    super.initState();

    // Initialize audio players
    _audioPlayer = AudioPlayer();
    _trapPlayer = AudioPlayer();
    _successPlayer = AudioPlayer();

    _startBackgroundMusic(); // Start playing background music

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
    _audioPlayer.dispose(); // Dispose background music player
    _trapPlayer.dispose(); // Dispose trap sound player
    _successPlayer.dispose(); // Dispose success sound player
    super.dispose();
  }

  // Function to play background music in a loop
  Future<void> _startBackgroundMusic() async {
    try {
      await _audioPlayer.setAsset(
          'assets/sounds/halloween_bg.mp3'); // Set background music file
      _audioPlayer.setLoopMode(LoopMode.one); // Loop the music
      _audioPlayer.play(); // Play the music
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Function to play the trap sound
  Future<void> _playTrapSound() async {
    try {
      await _trapPlayer.setAsset('assets/sounds/scary.mp3');
      _trapPlayer.play();
    } catch (e) {
      print("Error playing trap sound: $e");
    }
  }

  // Function to play the success sound
  Future<void> _playSuccessSound() async {
    try {
      await _successPlayer.setAsset('assets/sounds/success.mp3');
      _successPlayer.play();
    } catch (e) {
      print("Error playing success sound: $e");
    }
  }

  // Function to show the winning message and play success sound
  void _showSuccessDialog() {
    _playSuccessSound(); // Play the success sound

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You Found It!"),
          content:
              Text("Congratulations! You successfully found the correct item."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame(); // Reset the game for replay
              },
              child: Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  // Function to reset the game
  void _resetGame() {
    setState(() {
      hasWon = false; // Reset the winning flag
    });
  }

  // Function to show the trap alert dialog
  void _showTrapDialog(BuildContext context, String message) {
    _playTrapSound(); // Play the trap sound
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
    // Get the screen size using MediaQuery
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image that scales to fit the screen size
          Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'assets/hal_background.png',
              fit: BoxFit.fill, // Ensure the image fills the screen
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
                    if (!hasWon) {
                      _showTrapDialog(
                          context, "You encountered a spooky ghost!");
                    }
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

          // Pumpkin (Safe - Correct Item)
          Positioned(
            bottom: 100,
            right: 50,
            child: GestureDetector(
              onTap: () {
                if (!hasWon) {
                  setState(() {
                    hasWon = true; // Mark the game as won
                  });
                  _showSuccessDialog(); // Show success dialog and play sound
                }
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
                    if (!hasWon) {
                      _showTrapDialog(context, "You got caught by the bats!");
                    }
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
                if (!hasWon) {
                  _showTrapDialog(context, "Beware! The candy is a trick!");
                }
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
