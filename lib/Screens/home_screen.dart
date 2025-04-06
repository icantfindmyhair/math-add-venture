import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_add_venture/Screens/mode_select.dart';
import 'adventure_mode.dart';
import 'bgm_controller.dart';
import 'bush_animation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Math",
                  style: TextStyle(
                      fontFamily: 'Game Bubble',
                      fontSize: 45,
                      color: Color(0xff2da43e)),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Add Venture",
                  style: TextStyle(
                      fontFamily: 'Game Bubble',
                      fontSize: 45,
                      color: Color(0xff2da43e)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                    backgroundColor: Color(0xff1e6f8f),
                  ),
                  onPressed: () {
                    AudioController.playSFX("assets/sounds/tap.mp3");
                    AudioController.stopBGM();
                    AdventureMode.startNextLevel(context);
                  },
                  child: Column(
                    children: [
                      FutureBuilder<int>(
                        future: SharedPreferences.getInstance()
                            .then((prefs) =>
                        prefs.getInt('adventure_level') ?? 1),
                        builder: (context, snapshot) {
                          return Text(
                            "Level ${snapshot.data ?? 1}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        },
                      ),
                      Text(
                        "Adventure Mode",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GameButton(title: 'Practice Mode', screen: ModeSelectScreen()),

                /// To reset level
                // ElevatedButton(
                //   onPressed: () async {
                //     SharedPreferences prefs = await SharedPreferences.getInstance();
                //     await prefs.setInt('adventure_level', 1); // Reset the level to 1
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('Level has been reset to 1')),
                //     );
                //     setState(() {
                //       // Trigger a rebuild to update the displayed level if necessary
                //     });
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                //     backgroundColor: Color(0xff55c76f), // Customize the button color as needed
                //   ),
                //   child: Text(
                //     "Reset Level to 1",
                //     style: TextStyle(fontSize: 20, color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                BushAnimation(),
                Image.asset(
                  'assets/images/bush1.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String title;
  final Widget screen;

  GameButton({required this.title, required this.screen});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
          backgroundColor: Color(0xff6DC0E0)),
      onPressed: ()  {
        AudioController.playSFX("assets/sounds/tap.mp3");
        AudioController.stopBGM();
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Text(title, style: TextStyle(fontSize: 20, color:Color(0xffffffff))),
    );

  }
}