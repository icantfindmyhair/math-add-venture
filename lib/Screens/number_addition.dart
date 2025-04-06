import 'package:flutter/material.dart';
import 'dart:math';

import 'bgm_controller.dart';
import 'home_screen.dart';

class NumberAddition extends StatefulWidget {
  final int minTarget;
  final int maxTarget;
  final int gridSize;
  final int numSelections;
  final bool isAdventureMode;
  final Function? onLevelComplete;

  NumberAddition({
    required this.minTarget,
    required this.maxTarget,
    required this.gridSize,
    required this.numSelections,
    required this.isAdventureMode,
    this.onLevelComplete,
  });

  @override
  _NumberAdditionState createState() => _NumberAdditionState();
}

class _NumberAdditionState extends State<NumberAddition> {
  late int targetNumber;
  late List<int> numbers;
  List<int> selectedNumbers = [];
  bool gameOver = false;
  int attempt = 0;
  int level = 1;
  int maxPracticeLevel = 10;
  int maxAdventureLevel = 3;
  String message = "";
  double fontSize = 20;
  int color = 0xff444054;

  @override
  void initState() {
    super.initState();
    AudioController.playBGM("assets/sounds/additionbgm.mp3");
    startLevel();
  }

  @override
  void dispose() {
    AudioController.stopBGM();
    super.dispose();
  }

  void startLevel() {
    if (widget.isAdventureMode) {
      if (level > maxAdventureLevel) {
        showGameOverDialog(widget.isAdventureMode);
        return;
      }
    } else {
      if (level > maxPracticeLevel) {
        showGameOverDialog(widget.isAdventureMode);
        return;
      }
    }

    final random = Random();
    Set<int> uniqueNumbers = {};

    do {
      uniqueNumbers.clear();
      while (uniqueNumbers.length < widget.numSelections) {
        int newNumber = random.nextInt(20) + 1;
        uniqueNumbers.add(newNumber);
      }
      targetNumber = uniqueNumbers.reduce((a, b) => a + b);
    } while (targetNumber > widget.maxTarget ||
        targetNumber < widget.minTarget);

    while (uniqueNumbers.length < widget.gridSize) {
      int newNumber = random.nextInt(widget.maxTarget) + 1;
      if (!uniqueNumbers.contains(newNumber) && newNumber != targetNumber) {
        uniqueNumbers.add(newNumber);
      }
    }

    numbers = uniqueNumbers.toList()
      ..shuffle();
    selectedNumbers.clear();
    message = "";

    setState(() {
      gameOver = false;
    });
  }

  void selectNumber(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else if (selectedNumbers.length < widget.numSelections) {
        selectedNumbers.add(number);
      }
    });
  }

  void deselectNumber() {
    setState(() {
      selectedNumbers.clear();
    });
  }

  void showFailedDialog() {
    AudioController.stopBGM();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffffffe3),
          title: Text("Oops!", textAlign: TextAlign.center, style: TextStyle(color: Color(0xff444054))),
          content: Text("Retry this level?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff444054),
              fontSize: 18,
            ),),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                        (route) => false,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffffffe3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xff444054),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    "Return Home",
                    style: TextStyle(
                      color: Color(0xff444054),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ),
            TextButton(
                onPressed: () {
                  AudioController.playBGM("assets/sounds/additionbgm.mp3");
                  Navigator.of(context).pop();
                  level = 1;
                  startLevel();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xff444054),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Retry",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ),
          ],
        );
      },
    );
  }

  void checkSelection() {
    if (selectedNumbers.length != widget.numSelections) {
      setState(() {
        AudioController.playSFX("assets/sounds/error.mp3");
        message = "⚠️ Select exactly ${widget.numSelections} numbers!";
        fontSize = 20;
        color = 0xff444054;
      });
      return;
    }

    int sum = selectedNumbers.reduce((a, b) => a + b);
    if (sum == targetNumber) {
      setState(() {
        AudioController.playSFX("assets/sounds/correct.mp3");
        level++;
        attempt = 0;
        message = "✅ Good Job!";
        fontSize = 30;
        color = 0xff2da43e;
      });
      Future.delayed(Duration(seconds: 1), () => startLevel());
    } else {
      setState(() {
        AudioController.playSFX("assets/sounds/error.mp3");
        attempt++;
        message = "❌ Try Again!";
        fontSize = 25;
        color = 0xffdb5f31;
      });
      if (widget.isAdventureMode) {
        setState(() {
          gameOver = true;
          showFailedDialog();
        });
      }
    }
  }

    Widget buildGridTile(int number) {
      bool isSelected = selectedNumbers.contains(number);
      return GestureDetector(
        onTap: () {
          AudioController.playSFX("assets/sounds/grids.mp3");
          selectNumber(number);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xfffbc02d) : Color(0xff397dc9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 4)
            ], // Added shadow
          ),
          child: Text(
            "$number",
            style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xfff5efeb)),
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                        (route) => false,
                  );
                },
              ),
              SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: "Select ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                        text: "${widget.numSelections} ",
                        style: TextStyle(fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff397dc9))
                    ),
                    TextSpan(
                        text: "numbers that makes",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text("$targetNumber", style: TextStyle(fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff061bb0))),
              SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (widget.gridSize <= 8) ? 4 : 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.2, // Square-like grid items
                  ),
                  itemCount: widget.gridSize,
                  itemBuilder: (context, index) =>
                      buildGridTile(numbers[index]),
                ),
              ),
              SizedBox(height: 10),
              Text(message, style: TextStyle(fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(color))),
              SizedBox(height: 5),
              Text(widget.isAdventureMode? "" : "Round: $level", style: TextStyle(fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff444054))),
              SizedBox(height: 5),
              Text(widget.isAdventureMode? "" : "Attempts: $attempt",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      deselectNumber();
                      AudioController.playSFX("assets/sounds/tap.mp3");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffffffe3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Color(0xff444054),
                          width: 2,
                        ),),
                    ),
                    child: Text("Deselect All", style: TextStyle(
                        fontSize: 20, color: Color(0xff444054))),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      checkSelection();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff444054),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Check", style: TextStyle(
                        fontSize: 20, color: Color(0xfff5efeb))),
                  )
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      );
    }

  void showGameOverDialog(bool isAdventureMode) {
    AudioController.stopBGM();
    AudioController.playSFX("assets/sounds/welldone.mp3");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (isAdventureMode) {
          return AlertDialog(
            backgroundColor: Color(0xffffffe3),
            title: Text("🎉 Congratulations!", textAlign: TextAlign.center),
            content: Text(
                "You have completed the level!", textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () {
                  AudioController.playBGM("assets/sounds/additionbgm.mp3");
                  Navigator.of(context).pop();
                  if (widget.onLevelComplete != null) {
                    widget.onLevelComplete!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff444054), // Background color of the b
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Next Level",
                  style: TextStyle(fontSize: 16, color: Color(0xffffffe3)),
                ),
              ),
            ],
          );
        } else {
          // Default dialog for normal game mode
          return AlertDialog(
            backgroundColor: Color(0xffffffe3),
            title: Text("🎉 Well Done!", textAlign: TextAlign.center, style: TextStyle(color: Color(0xff444054))),
            content: Text(
                "You completed all levels.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            actions: [
              TextButton(
                onPressed: () {
                  AudioController.playBGM("assets/sounds/additionbgm.mp3");
                  Navigator.of(context).pop();
                  level = 1;
                  startLevel();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff444054),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Play Again",
                  style: TextStyle(fontSize: 16, color: Color(0xffffffff)),
                ),
              ),
            ],
          );
        }
      },
    );
  }
  }
