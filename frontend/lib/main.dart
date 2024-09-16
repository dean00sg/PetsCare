import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_feedpost.dart'; // Ensure correct import
import 'package:frontend/admin/repositories/add_feedpost.dart'; // Ensure correct import

import 'package:frontend/admin/widget/add_feedpost.dart'; // Correct imports
import 'package:frontend/admin/widget/feed_admin.dart';
import 'package:frontend/admin/widget/notification_main.dart';
import 'package:frontend/users/bloc/login_bloc.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/bloc/signup_bloc.dart';
import 'package:frontend/users/repositories/login_repository.dart';
import 'package:frontend/users/repositories/profile_repository.dart';
import 'package:frontend/users/repositories/signup_repository.dart';
import 'package:frontend/users/widget_screen/feed_screen.dart';
import 'package:frontend/users/widget_screen/login_screen.dart';
import 'package:frontend/users/widget_screen/profile.dart';
import 'package:frontend/users/widget_screen/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(loginRepository: LoginRepository()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(profileRepository: ProfileRepository(apiUrl: 'http://127.0.0.1:8000')),
        ),
        BlocProvider(
          create: (context) => SignupBloc(signupRepository: SignupRepository()),
        ),
        BlocProvider(
          create: (context) => AddFeedBloc(repository: AddFeedRepository()), // Correct parameter name
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
          '/feedadmin': (context) => const FeedadminScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/notifications': (context) => const NotificationWidget(),
          '/addfeedpost': (context) => const FeedPostWidget(),
        },
      ),
    );
  }
}
