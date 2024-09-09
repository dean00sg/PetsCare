import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/signup_bloc.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart'; // Import CreatePetBloc
import 'package:frontend/users/models/create_pet_model.dart';
import 'package:frontend/users/models/pet_models.dart';
import 'package:frontend/users/repositories/signup_repository.dart';
import 'package:frontend/users/widget_screen/create_pet_screen.dart';
import 'package:frontend/users/widget_screen/feed_screen.dart';
import 'package:frontend/users/widget_screen/login_screen.dart';
import 'package:frontend/users/widget_screen/pet_details_screen.dart';
import 'package:frontend/users/widget_screen/pet_screen.dart';
import 'package:frontend/users/widget_screen/signup_screen.dart';

void main() {
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(signupRepository: SignupRepository()),
        ),
        BlocProvider<CreatePetBloc>( // Add CreatePetBloc
          create: (context) => CreatePetBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Pet Care',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/feed': (context) => const FeedScreen(),
          '/create_pet': (context) {
            final Pet petData = ModalRoute.of(context)?.settings.arguments as Pet;
            return CreatePetScreen(pet: petData); // ส่งค่า pet ที่จำเป็น
          },
          '/pet': (context) => const PetScreen(),
          '/pet_details': (context) {
            final PetModel petData = ModalRoute.of(context)?.settings.arguments as PetModel;
            return PetDetailsScreen(pet: petData);
          },
//           // '/profile': (context) {
//           //   final SignupModel signupData = ModalRoute.of(context)?.settings.arguments as SignupModel;
//           //   return ProfileUser(userData: signupData);
//           // },
        },
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/users/bloc/signup_bloc.dart';
// import 'package:frontend/users/repositories/signup_repository.dart';
// import 'package:frontend/users/widget_screen/create_pet_screen.dart';
// import 'package:frontend/users/widget_screen/feed_screen.dart';
// import 'package:frontend/users/widget_screen/login_screen.dart';
// import 'package:frontend/users/widget_screen/pet_screen.dart';
// import 'package:frontend/users/widget_screen/signup_screen.dart';

// void main() {
//   runApp(const PetCareApp());
// }

// class PetCareApp extends StatelessWidget {
//   const PetCareApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<SignupBloc>(
//           create: (context) => SignupBloc(signupRepository: SignupRepository()),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Pet Care',
//         theme: ThemeData(
//           primarySwatch: Colors.brown,
//         ),
//         initialRoute: '/',
//         routes: {
//           '/': (context) => const LoginScreen(),
//           '/signup': (context) => SignupScreen(),
//           '/feed': (context) => const FeedScreen(),
//           '/create_pet': (context) => const CreatePetScreen(),
//           '/pet': (context) => const PetScreen(),
//         },
//       ),
//     );
//   }
// }
