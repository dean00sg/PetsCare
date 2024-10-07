import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_feedpost.dart'; // Ensure correct import
import 'package:frontend/admin/bloc/add_healthrec.dart';
import 'package:frontend/admin/bloc/add_historyrec.dart';
import 'package:frontend/admin/bloc/add_notification.dart';
import 'package:frontend/admin/bloc/add_vaccination.dart';
import 'package:frontend/admin/bloc/check_historyrec.dart';
import 'package:frontend/admin/bloc/user.dart';
import 'package:frontend/admin/bloc/vaccination.dart';
import 'package:frontend/admin/repositories/add_feedpost.dart'; // Ensure correct import
import 'package:frontend/admin/bloc/check_info_bloc.dart';
import 'package:frontend/admin/repositories/add_notification.dart';
import 'package:frontend/admin/repositories/historyrec.dart';
import 'package:frontend/admin/repositories/user_repository.dart';
import 'package:frontend/admin/repositories/vaccination.dart';
import 'package:frontend/admin/widget/add_healthrec.dart';
import 'package:frontend/admin/widget/add_historyrec.dart';
import 'package:frontend/admin/widget/add_notification.dart';
import 'package:frontend/admin/widget/add_vaccination.dart';
import 'package:frontend/admin/widget/check_alluser.dart';
import 'package:frontend/admin/widget/check_healthrec.dart';
import 'package:frontend/admin/widget/check_historyrec.dart';
import 'package:frontend/admin/widget/check_info_screen.dart';
import 'package:frontend/admin/widget/add_feedpost.dart'; // Correct imports
import 'package:frontend/admin/widget/feed_admin.dart';
import 'package:frontend/admin/widget/healthrecord_main.dart';
import 'package:frontend/admin/widget/historyrec_main.dart';
import 'package:frontend/admin/widget/notification_main.dart';
import 'package:frontend/admin/widget/petprofileuser.dart';
import 'package:frontend/admin/widget/profile.dart';
import 'package:frontend/admin/bloc/chechhealth_rec.dart';
import 'package:frontend/admin/widget/check_vaccination.dart';
import 'package:frontend/admin/widget/vaccination_main.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart';
import 'package:frontend/users/bloc/historyrec_pet.dart';
import 'package:frontend/users/bloc/login_bloc.dart';
import 'package:frontend/users/bloc/petprofile.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/bloc/signup_bloc.dart';
import 'package:frontend/users/bloc/add_vaccination.dart';
import 'package:frontend/admin/repositories/chechhealth_rec.dart';
import 'package:frontend/users/bloc/vaccination_pet.dart';
import 'package:frontend/users/repositories/historyrec_pet.dart';
import 'package:frontend/users/repositories/login_repository.dart';
import 'package:frontend/users/repositories/petprofile.dart';
import 'package:frontend/users/repositories/petsgetall.dart';
import 'package:frontend/users/repositories/profile_repository.dart';
import 'package:frontend/users/repositories/signup_repository.dart';
import 'package:frontend/users/repositories/vaccination_pet.dart';
import 'package:frontend/users/repositories/vaccination.dart';
import 'package:frontend/users/widget_screen/create_pet_screen.dart';
import 'package:frontend/users/widget_screen/feed_screen.dart';
import 'package:frontend/users/widget_screen/historyrec_pet.dart';
import 'package:frontend/users/widget_screen/login_screen.dart';
import 'package:frontend/users/widget_screen/notification.dart';
import 'package:frontend/users/widget_screen/pet_screen.dart';
import 'package:frontend/users/widget_screen/petprofile.dart';
import 'package:frontend/users/widget_screen/profile.dart';
import 'package:frontend/users/widget_screen/signup_screen.dart';
import 'package:frontend/users/widget_screen/vaccination_pet.dart';
import 'package:frontend/users/widget_screen/addvaccinepet.dart' ;


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
          create: (context) => UserBloc(userRepository: UserRepository()),
        ),
        BlocProvider(
          create: (context) => AddNotificationBloc(
            notificationRepository: AddNotificationUserRepository(apiUrl: 'http://10.0.2.2:8000'),
            userListRepository: UserListRepository(), // Add this line
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
              profileRepository: ProfileRepository(apiUrl: 'http://10.0.2.2:8000')),
        ),
        BlocProvider(
          create: (context) => SignupBloc(signupRepository: SignupRepository()),
        ),
        BlocProvider(
          create: (context) => AddFeedBloc(repository: AddFeedRepository()),
        ),
        BlocProvider(
          create: (context) => CreatePetBloc(createPetRepository: CreatePetRepository()),
        ),
        BlocProvider(
          create: (context) => AdminCheckInfoBloc(),
        ),
        BlocProvider(
          create: (context) => PetProfileBloc(PetProfileRepository()),
        ),
        BlocProvider(
          create: (context) => HealthRecordBloc(HealthRecordRepository()),
        ),
        BlocProvider(
          create: (context) => AddHealthRecordBloc(HealthRecordRepository()),
          child: const AddHealthRecordForm(),
        ),
        BlocProvider(
          create: (context) => PetVacBloc(
            petVacRepository: PetVacRepository(apiUrl: 'http://10.0.2.2:8000'), 
          ),
        ),
        BlocProvider(
          create: (context) => AddVaccinationBloc(
            PetVacRepository(apiUrl: 'http://10.0.2.2:8000'), 
          ),
          child: const AddVaccinationScreen(),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(
            repository: HistoryRepository(apiUrl: 'http://10.0.2.2:8000'),
          ),
        ),
        BlocProvider(
          create: (context) => AddHistoryRecBloc(
            HistoryRepository(apiUrl: 'http://10.0.2.2:8000'), // Pass the repository
          ),
          child: const AddHistoryRecScreen(), // Wrap with BlocProvider
        ),
        BlocProvider<PetVacUserBloc>(
          create: (context) => PetVacUserBloc(PetVacUserRepository()),
        ),
         BlocProvider(
          create: (context) => HistoryRecUserBloc(HistoryRecUserRepository()),
        ),
        BlocProvider(
          create: (context) => VaccinationBloc(UserPetVacRepository(apiUrl: 'http://10.0.2.2:8000')),
        ),
      ],
      child: MaterialApp(
        title: 'Pet Care',
        debugShowCheckedModeBanner: false,
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
          '/petsprofileuser': (context) => const PetProfileUserScreen(),
          '/checkAllUsersScreen': (context) => CheckAllUsersScreen(),
          '/notificationUser': (context) => const NotificationUser(),
          '/addnotificationUser': (context) => const AddNotificationScreen(),
          '/petsprofile': (context) => const PetProfileScreen(),
          '/healthrecordmain': (context) => const HealthrecordMainWidget(),
          '/vaccinationmain': (context) => const VaccinationMainWidget(),
          '/checkhealthrec': (context) => const HealthRecordScreen(),
          '/addhealthrec': (context) => const AddHealthRecordForm(),
          '/checkvaccination': (context) => const PetVacProfilesScreen(),
          '/addvaccination': (context) => const AddVaccinationScreen(),
          '/historyrecmain': (context) => const HistoryRecMainWidget(),
          '/checkhistoryrec':(context) => const HistoryScreen(),
          '/addhistoryrec': (context) => const AddHistoryRecScreen(),
          '/vaccinepet': (context) => const VaccinePetsScreen(),
          '/historyrec': (context) => const HistoryRecUserScreen(),
          '/addvaccinepet': (context) => const AddvaccinePetsScreen(),
          


        },
      ),
    );
  }
}
