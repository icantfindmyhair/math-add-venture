import 'package:flutter/material.dart';
import 'dart:math';

import 'bgm_controller.dart';
import 'home_screen.dart';

class NumberOrder extends StatefulWidget {
  final int minNumber;
  final int maxNumber;
  final int numberOfGrids;
  final bool haveDescending;
  final bool isAdventureMode;
  final Function? onLevelComplete;

  NumberOrder({
    required this.minNumber,
    required this.maxNumber,
    required this.numberOfGrids,
    required this.haveDescending,
    required this.isAdventureMode,
    this.onLevelComplete,
  });

  @override
  _NumberOrderState createState() => _NumberOrderState();
}

class _NumberOrderState extends State<NumberOrder> {
  late List<int> numbers;
  late List<int> correctOrder;
  late bool isAscending;
  String message = "";
  int color = 0x444054;
  bool gameOver = false;
  int level = 1;
  int maxAdventureLevel = 3;
  int maxPracticeLevel = 10;

  @override
  void initState() {
    super.initState();
    AudioController.playBGM("assets/sounds/orderbgm.mp3");
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

    while (uniqueNumbers.length < widget.numberOfGrids) {
      uniqueNumbers.add(random.nextInt(widget.maxNumber - widget.minNumber + 1) + widget.minNumber);
    }

    numbers = uniqueNumbers.toList();
    numbers.shuffle();

    isAscending = widget.haveDescending ? random.nextBool() : true;

    correctOrder = List.from(numbers)..sort();
    if (!isAscending) {
      correctOrder = correctOrder.reversed.toList();
    }

    gameOver = false;
    message = "";
    setState(() {});
  }

  void checkOrder() {
    if (numbers.join() == correctOrder.join()) {
      AudioController.playSFX("assets/sounds/correct.mp3");
      setState(() {
        message = "✅ Good Job!";
        color = 0xff2da43e;
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          level++;
          startLevel();
        });
      });
    } else {
      AudioController.playSFX("assets/sounds/error.mp3");
      if(widget.isAdventureMode){
        showFailedDialog();
      }
      else{
        setState(() {
          message = "❌ Try Again!";
          color = 0xffdb5f31;
        });
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
                  AudioController.playBGM("assets/sounds/orderbgm.mp3");
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
                  AudioController.playBGM("assets/sounds/orderbgm.mp3");
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
                AudioController.playBGM("assets/sounds/orderbgm.mp3");
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

  Widget buildDraggableTile(int index) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(numbers[index].toString(),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: DragTarget<int>(
        onAccept: (draggedIndex) {
          setState(() {
            final draggedItem = numbers.removeAt(draggedIndex);
            numbers.insert(index, draggedItem);
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xff11a1dc),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(numbers[index].toString(),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 5),
            Text(
              widget.isAdventureMode? "" : "Round $level",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff444054)),
            ),
            SizedBox(height: 5),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Arrange the numbers in ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: isAscending ? 'Ascending' : 'Descending',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isAscending ? Color(0xff16a637) : Color(0xffed5f1e),
                    ),
                  ),
                  TextSpan(
                    text: " order",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: numbers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.numberOfGrids <= 4 ? 4 : 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: widget.numberOfGrids <= 4 ? 0.9 : 1.2,
                ),
                itemBuilder: (context, index) => buildDraggableTile(index),
              ),
            ),

            SizedBox(height: 10),
            Text(message, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(color))),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                checkOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff444054),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Check Order", style: TextStyle(fontSize:20, color: Color(0xfff5efeb))),
            ),
          ],
        ),
      ),
    );
  }
}
