import 'package:flutter/material.dart';
import 'package:frontend/widget_screen/feed_screen.dart';
import 'package:frontend/widget_screen/login_screen.dart';
import 'package:frontend/widget_screen/signin_screen.dart';


void main() {
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/feed': (context) => const FeedScreen(),
      },
    );
  }
}
