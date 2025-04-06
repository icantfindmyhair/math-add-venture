import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Game',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Jua',
          scaffoldBackgroundColor: Color(0xFFFFFFE3),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF444054)),
            bodyMedium: TextStyle(color: Color(0xFF444054)),
          ),
      ),
      home: HomeScreen(),
    );
  }
}
