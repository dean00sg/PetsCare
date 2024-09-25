import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/petprofile.dart';
import 'package:frontend/users/event/petprofile.dart';
import 'package:frontend/users/models/petprofile.dart';
import 'package:frontend/users/state/petprofile.dart';
import 'package:frontend/users/styles/petprofile_style.dart';
import 'package:frontend/users/widget_screen/editpetprofile_screen.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petName = ModalRoute.of(context)?.settings.arguments as String;

    context.read<PetProfileBloc>().add(LoadPetProfile(petName));

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(petName, style: const TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: PetProfileStyles.appBarBackgroundColor,
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
          if (state is PetProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PetProfileError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is PetProfileLoaded) {
            final pet = state.petProfile;
            final petAge = calculateAge(DateTime.parse(pet.birthDate));
            final imagePath = PetTypeImage.getImagePath(pet.typePets);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(16.0),
                decoration: PetProfileStyles.containerBoxDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(imagePath),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                pet.name,
                                style: PetProfileStyles.petNameTextStyle,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: PetProfileStyles.editIcon,
                                iconSize: PetProfileStyles.iconSize,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPetProfileScreen(petProfile: pet),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Text('${pet.typePets}, ${pet.sex}', style: PetProfileStyles.petInfoTextStyle),
                          const SizedBox(height: 5),
                          Text(
                            '${pet.birthDate}, Age: ${petAge['years']} Y ${petAge['months']} M ${petAge['days']} D',
                            style: PetProfileStyles.petInfoTextStyle,
                          ),
                          const SizedBox(height: 5),
                          Text('Weight: ${pet.weight} kg', style: PetProfileStyles.petInfoTextStyle),
                          const SizedBox(height: 5),
                          Text('BREED : ${pet.breed}', style: PetProfileStyles.petInfoTextStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No pet data available'));
          }
        },
      ),
    );
  }

  // ฟังก์ชันคำนวณอายุ
  Map<String, int> calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;
    int days = today.day - birthDate.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(today.year, today.month, 0).day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    return {'years': years, 'months': months, 'days': days};
  }
}
