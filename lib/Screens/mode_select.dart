import 'package:flutter/material.dart';
import 'bgm_controller.dart';
import 'difficulty_screen.dart';

class ModeSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Game",
              style: TextStyle(
                  fontFamily: 'Game Bubble',
                  fontSize: 34,
                  color: Color(0xff2da43e),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GameButton(
                title: 'Number Compare',
                screen: DifficultyScreen(gameType: 'compare',),
                backgroundColor: Color(0xFFCC3845),
                textColor: Color(0xFFFFFFFF)),
            SizedBox(height: 10),
            GameButton(
                title: 'Number Order',
                screen: DifficultyScreen(gameType: 'order'),
                backgroundColor: Color(0xFFDB5F31),
                textColor: Color(0xFFFFFFFF)),
            SizedBox(height: 10),
            GameButton(
                title: 'Number Addition',
                screen: DifficultyScreen(gameType: 'addition'),
                backgroundColor: Color(0xFF085E9D),
                textColor: Color(0xFFFFFFFF)),
          ],
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String title;
  final Widget screen;
  final Color backgroundColor;
  final Color textColor;

  GameButton({
    required this.title,
    required this.screen,
    required this.backgroundColor,
    required this.textColor,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          backgroundColor: backgroundColor),
      onPressed: () {
        AudioController.playSFX("assets/sounds/click.mp3");
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Text(title, style: TextStyle(fontSize: 20, color: textColor)),
    );
  }
}
