import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'number_addition.dart';
import 'number_compare.dart';
import 'number_order.dart';

class AdventureMode {
  static Future<int> _getCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('adventure_level') ?? 1;
  }

  static Future<void> _setNextLevel(int nextLevel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('adventure_level', nextLevel);
  }

  static void startNextLevel(BuildContext context) async {
    int level = await _getCurrentLevel();

    List<Map<String, dynamic>> levels = [
      {'type': 'compare', 'difficulty': 'Easy', 'maxNumber': 50, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': 'Easy', 'minNumber': 10, 'maxNumber': 50, 'numberOfGrids': 4, 'haveDescending': false, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': 'Easy', 'minTarget': 10, 'maxTarget': 20, 'gridSize': 4, 'numSelections': 2, 'isAdventureMode': true},

      {'type': 'compare', 'difficulty': 'Easy', 'maxNumber': 100, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': 'Easy', 'minTarget': 15, 'maxTarget': 25, 'gridSize': 6, 'numSelections': 2, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': 'Easy', 'minNumber': 10, 'maxNumber': 60, 'numberOfGrids': 4, 'haveDescending': false, 'isAdventureMode': true},

      {'type': 'compare', 'difficulty': "Easy", 'maxNumber': 100, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': "Easy", 'minTarget': 15, 'maxTarget': 25, 'gridSize': 6, 'numSelections': 2, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': "Easy", 'minNumber': 10, 'maxNumber': 60, 'numberOfGrids': 4, 'haveDescending': true, 'isAdventureMode': true},

      {'type': 'compare', 'difficulty': 'Normal', 'maxNumber': 200, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': 'Normal', 'minTarget': 20, 'maxTarget': 40, 'gridSize': 6, 'numSelections': 2, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': 'Easy', 'minNumber': 10, 'maxNumber': 70, 'numberOfGrids': 4, 'haveDescending': true, 'isAdventureMode': true},

      {'type': 'compare', 'difficulty': "Normal", 'maxNumber': 300, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': "Normal", 'minNumber': 20, 'maxNumber': 80, 'numberOfGrids': 5, 'haveDescending': true, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': "Normal", 'minTarget': 30, 'maxTarget': 60, 'gridSize': 6, 'numSelections': 2, 'isAdventureMode': true},

      {'type': 'compare', 'difficulty': 'Easy', 'maxNumber': 150, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': 'Hard', 'minNumber': 10, 'maxNumber': 100, 'numberOfGrids': 6, 'haveDescending': true, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': 'Normal', 'minTarget': 20, 'maxTarget': 60, 'gridSize': 6, 'numSelections': 3, 'isAdventureMode': true},

      {'type': 'order', 'difficulty': 'Normal', 'minNumber': 10, 'maxNumber': 90, 'numberOfGrids': 5, 'haveDescending': true, 'isAdventureMode': true},
      {'type': 'compare', 'difficulty': 'Hard', 'maxNumber': 500, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': 'Easy', 'minTarget': 10, 'maxTarget': 25, 'gridSize': 4, 'numSelections': 2, 'isAdventureMode': true},

      {'type': 'compare', 'difficulty': 'Easy', 'maxNumber': 100, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': 'Easy', 'minNumber': 10, 'maxNumber': 50, 'numberOfGrids': 4, 'haveDescending': false, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': 'Easy', 'minTarget': 15, 'maxTarget': 30, 'gridSize': 4, 'numSelections': 2, 'isAdventureMode': true},

      {'type': 'order', 'difficulty': 'Hard', 'minNumber': 10, 'maxNumber': 120, 'numberOfGrids': 6, 'haveDescending': true, 'isAdventureMode': true},
      {'type': 'compare', 'difficulty': 'Normal', 'maxNumber': 500, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': 'Easy', 'minTarget': 15, 'maxTarget': 30, 'gridSize': 4, 'numSelections': 2, 'isAdventureMode': true},

      {'type': 'compare', 'difficulty': "Hard", 'maxNumber': 999, 'isAdventureMode': true},
      {'type': 'order', 'difficulty': "Hard", 'minNumber': 50, 'maxNumber': 120, 'numberOfGrids': 6, 'haveDescending': true, 'isAdventureMode': true},
      {'type': 'addition', 'difficulty': "Hard", 'minTarget': 50, 'maxTarget': 100, 'gridSize': 8, 'numSelections': 3, 'isAdventureMode': true},
    ];

    Map<String, dynamic> currentLevel = levels[(level - 1) % levels.length];

    switch (currentLevel['type']) {
      case 'compare':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => NumberCompare(
            maxNumber: currentLevel['maxNumber'],
            isAdventureMode: true,
            onLevelComplete: () async {
              int newLevel = level + 1;
              await _setNextLevel(newLevel);
              startNextLevel(context);
            },
          ),
        ));
        break;
      case 'order':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => NumberOrder(
            minNumber: currentLevel['minNumber'],
            maxNumber: currentLevel['maxNumber'],
            numberOfGrids: currentLevel['numberOfGrids'],
            haveDescending: currentLevel['haveDescending'],
            isAdventureMode: true,
            onLevelComplete: () async {
              int newLevel = level + 1;
              await _setNextLevel(newLevel);
              startNextLevel(context);
            },
          ),
        ));
        break;
      case 'addition':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => NumberAddition(
            minTarget: currentLevel['minTarget'],
            maxTarget: currentLevel['maxTarget'],
            gridSize: currentLevel['gridSize'],
            numSelections: currentLevel['numSelections'],
            isAdventureMode: true,
            onLevelComplete: () async {
              int newLevel = level + 1;
              await _setNextLevel(newLevel);
              startNextLevel(context);
            },
          ),
        ));
        break;
    }
  }
}

