import 'dart:async';
import 'package:flutter/material.dart';
import 'bgm_controller.dart';
import 'home_screen.dart';
import 'dart:math';

class NumberCompare extends StatefulWidget {
  final int maxNumber;
  final bool isAdventureMode;
  final Function? onLevelComplete;

  const NumberCompare({Key? key,
    required this.maxNumber,
    required this.isAdventureMode,
    this.onLevelComplete,
  }) : super(key: key);

  @override
  _NumberCompareState createState() => _NumberCompareState();
}

class _NumberCompareState extends State<NumberCompare> {
  late int num1;
  late int num2;
  String message = "";
  int score = 0;
  int level = 1;
  int maxPracticeLevel = 9; /// set 1 lower than intended
  int maxAdventureLevel = 2;
  int color = 0xff444054;
  bool chooseBigger = true;

  @override
  void initState() {
    super.initState();
    AudioController.playBGM("assets/sounds/comparebgm.mp3");
    startLevel();
  }

  @override
  void dispose() {
    AudioController.stopBGM();
    super.dispose();
  }

  void startLevel() {
    final random = Random();
    setState(() {
      chooseBigger = Random().nextBool();
      num1 = random.nextInt(widget.maxNumber) + 1;
      num2 = random.nextInt(widget.maxNumber) + 1;
      while (num1 == num2) {
        num2 = random.nextInt(widget.maxNumber) + 1;
      }
      message = "";
    });
  }

  void checkAnswer(int selectedNumber) async {
    int correctAnswer = chooseBigger
        ? (num1 > num2 ? num1 : num2)
        : (num1 < num2 ? num1 : num2);

    bool isCorrect = selectedNumber == correctAnswer;

    setState(() {
      if (isCorrect) {
        message = "✅ Good Job!";
        color = 0xff2da43e;
        score++;
        AudioController.playSFX("assets/sounds/correct.mp3");
      } else {
        if (widget.isAdventureMode) {
          showFailedDialog();
        } else {
          message = "❌ Try Again!";
          color = 0xffdb5f31;
          AudioController.playSFX("assets/sounds/error.mp3");
        }
      }
    });

    await Future.delayed(Duration(seconds: 1));

    if (isCorrect) {
      if (widget.isAdventureMode) {
        if (level > maxAdventureLevel) {
          AudioController.stopBGM();
          showGameOverDialog(widget.isAdventureMode);
        } else {
          startLevel();
          level++;
        }
      } else {
        if (level > maxPracticeLevel) {
          AudioController.stopBGM();
          showGameOverDialog(widget.isAdventureMode);
        } else {
          startLevel();
          level++;
        }
      }
    }
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
                  AudioController.playBGM("assets/sounds/comparebgm.mp3");
                  Navigator.of(context).pop();
                  if (widget.onLevelComplete != null) {
                    widget.onLevelComplete!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff444054),
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
          return AlertDialog(
            backgroundColor: Color(0xffffffe3),
            title: Text("🎉 Well Done!", textAlign: TextAlign.center, style: TextStyle(color: Color(0xff444054))),
            content: Text(
                "You completed all levels.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            actions: [
              TextButton(
                onPressed: () {
                  AudioController.playBGM("assets/sounds/comparebgm.mp3");
                  Navigator.of(context).pop();
                  resetGame();
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
                  AudioController.playBGM("assets/sounds/comparebgm.mp3");
                  Navigator.of(context).pop();
                  resetGame();
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

  void resetGame() {
    setState(() {
      score = 0;
      level = 1;
      startLevel();
    });
  }

  Widget numberBubble(int number) {
    return GestureDetector(
      onTap: () {
        AudioController.playSFX("assets/sounds/tap.mp3");
        checkAnswer(number);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xff11a1dc),
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xff11a1dc),
            width: 4,
          ),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Text(
            widget.isAdventureMode? "" : "Round $level",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff444054)),
          ),
          SizedBox(height: 40),
          Text(
            chooseBigger ? 'Tap the bigger number!' : 'Tap the smaller number!',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              numberBubble(num1),
              SizedBox(width: 40),
              numberBubble(num2),
            ],
          ),

          SizedBox(height: 30),
          Text(message, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(color))),
          SizedBox(height: 20),
          Text(widget.isAdventureMode? "" : 'Score: $score', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
