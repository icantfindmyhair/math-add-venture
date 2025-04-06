import 'package:flutter/material.dart';
import 'bgm_controller.dart';
import 'number_compare.dart';
import 'number_addition.dart';
import 'number_order.dart';

class DifficultyScreen extends StatelessWidget {
  final String gameType;

  DifficultyScreen({required this.gameType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Difficulty",
              style: TextStyle(
                fontFamily: 'Game Bubble',
                fontSize: 34,
                color: Color(0xff2da43e),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ..._buildDifficultyButtons(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDifficultyButtons(BuildContext context) {
    if (gameType == "compare") {
      return [
        _compareButton(context, "Easy", 50, false),
        _compareButton(context, "Normal", 500, false),
        _compareButton(context, "Hard", 999, false),
      ];
    } else if (gameType == "addition") {
      return [
        _additionButton(context, "Easy",10, 30, 4, 2, false),
        _additionButton(context, "Normal",20, 50, 8, 2, false),
        _additionButton(context, "Hard",20, 60, 8, 3, false),
      ];
    } else if (gameType == "order") {
      return [
        _orderButton(context, "Easy",10, 50, 4, false, false),
        _orderButton(context, "Normal",10, 80, 4, true, false),
        _orderButton(context, "Hard",10, 100, 6, true, false),
      ];
    }else {
      return [Text("Invalid Game Type")];
    }
  }

  Widget _compareButton(BuildContext context, String difficulty, int maxNumber, bool isAdventureMode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          backgroundColor: Color(0xFFCC3845)),
      onPressed: (){
        AudioController.playSFX("assets/sounds/click.mp3");
        AudioController.stopBGM();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NumberCompare(maxNumber: maxNumber, isAdventureMode: isAdventureMode,)),
        );
      },
      child: Text(difficulty, style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF))),
    );
  }

  Widget _additionButton(BuildContext context, String difficulty, int minTarget,
      int maxTarget, int gridSize, int numSelections, bool isAdventureMode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          backgroundColor: Color(0xFF085E9D)),
      onPressed: (){
        AudioController.playSFX("assets/sounds/click.mp3");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NumberAddition(minTarget: minTarget, maxTarget: maxTarget,
              gridSize: gridSize, numSelections: numSelections, isAdventureMode: isAdventureMode,)),
        );
      },
      child: Text(difficulty, style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF))),
    );
  }

  Widget _orderButton(BuildContext context, String difficulty, int minNumber, int maxNumber,
      int numberOfGrids, bool haveDescending, bool isAdventureMode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          backgroundColor: Color(0xFFDB5F31)),
      onPressed: (){
        AudioController.playSFX("assets/sounds/click.mp3");
        AudioController.stopBGM();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NumberOrder(minNumber: minNumber, maxNumber: maxNumber,
              numberOfGrids: numberOfGrids, haveDescending: haveDescending, isAdventureMode: isAdventureMode,)),
        );
      },
      child: Text(difficulty, style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF))),
    );
  }
}
