import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_feedpost.dart'; // Ensure correct import
import 'package:frontend/admin/bloc/user.dart';
import 'package:frontend/admin/repositories/add_feedpost.dart'; // Ensure correct import
import 'package:frontend/admin/bloc/check_info_bloc.dart';
import 'package:frontend/admin/repositories/user_repository.dart';
import 'package:frontend/admin/widget/check_alluser.dart';
import 'package:frontend/admin/widget/check_info_screen.dart';
import 'package:frontend/admin/widget/add_feedpost.dart'; // Correct imports
import 'package:frontend/admin/widget/feed_admin.dart';
import 'package:frontend/admin/widget/notification_main.dart';
import 'package:frontend/admin/widget/petprofile.dart';
import 'package:frontend/admin/widget/profile.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart';
import 'package:frontend/users/bloc/login_bloc.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/bloc/signup_bloc.dart';
import 'package:frontend/users/repositories/login_repository.dart';
import 'package:frontend/users/repositories/pets_repository.dart';
import 'package:frontend/users/repositories/profile_repository.dart';
import 'package:frontend/users/repositories/signup_repository.dart';
import 'package:frontend/users/widget_screen/create_pet_screen.dart';
import 'package:frontend/users/widget_screen/feed_screen.dart';
import 'package:frontend/users/widget_screen/login_screen.dart';
import 'package:frontend/users/widget_screen/notification.dart';
import 'package:frontend/users/widget_screen/pet_screen.dart';
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
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            userRepository: UserRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
              profileRepository:
                  ProfileRepository(apiUrl: 'http://10.0.2.2:8000')),
        ),
        BlocProvider(
          create: (context) => SignupBloc(signupRepository: SignupRepository()),
        ),
        BlocProvider(
          create: (context) => AddFeedBloc(
              repository: AddFeedRepository()), // Correct parameter name
        ),
        BlocProvider(
          create: (context) =>
              CreatePetBloc(createPetRepository: CreatePetRepository()),
        ),
        BlocProvider(
          create: (context) => AdminCheckInfoBloc(),
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
          '/profileadmin': (context) => const ProfileAdminScreen(),
          '/notifications': (context) => const NotificationWidget(),
          '/addfeedpost': (context) => const FeedPostWidget(),
          '/createpetsmain': (context) => const PetSMaincreen(),
          '/createpets': (context) => const CreatePetScreen(),
          '/checkinfo': (context) => const AdminCheckInfoScreen(),
          '/petsprofile': (context) => const PetProfileScreen(),
          '/checkAllUsersScreen': (context) => CheckAllUsersScreen(),
          '/notificationUser': (context) => const NotificationUser(),
        },
      ),
    );
  }
}
