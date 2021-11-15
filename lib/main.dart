import 'package:cubos_movies/view/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CubosMovies",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
