import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/login_bloc.dart';
import 'package:frontend/users/bloc/signup_bloc.dart';
import 'package:frontend/users/repositories/login_repository.dart';
import 'package:frontend/users/repositories/signup_repository.dart';

import 'package:frontend/users/widget_screen/feed_screen.dart';
import 'package:frontend/users/widget_screen/login_screen.dart';
import 'package:frontend/users/widget_screen/signup_screen.dart'; // Import Signup screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(loginRepository: LoginRepository()),
        ),
        BlocProvider(
          create: (context) => SignupBloc(signupRepository: SignupRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Pet Care',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/feed': (context) => const FeedScreen(),
        },
      ),
    );
  }
}
