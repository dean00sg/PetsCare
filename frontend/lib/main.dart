import 'package:flutter/material.dart';
import 'package:frontend/widget_screen/create_pet_screen.dart';
import 'package:frontend/widget_screen/feed_screen.dart';
import 'package:frontend/widget_screen/login_screen.dart';
import 'package:frontend/widget_screen/pet_screen.dart';
//import 'package:frontend/widget_screen/profile_user.dart';
import 'package:frontend/widget_screen/signup_screen.dart';


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
        '/create_pet': (context) => const CreatePetScreen(),
        '/pet': (context) => const PetScreen(),
       // '/profile': (context) => const ProfileUser(userData: signupData,), // ส่งข้อมูล userData จาก SignupModel
      },
    );
  }
}
