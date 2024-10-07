import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/petprofile.dart';
import 'package:frontend/users/event/petprofile.dart';
import 'package:frontend/users/models/petprofile.dart';
import 'package:frontend/users/state/petprofile.dart';
import 'package:frontend/users/styles/petprofile_style.dart';
import 'package:frontend/users/widget_screen/editpetprofile.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final petsId = arguments['petsId'] as int;

    context.read<PetProfileBloc>().add(LoadPetProfile(petsId.toString()));

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Pet Profile', style: TextStyle(fontSize: 22, color: Colors.white)),
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
              child: Column(
                children: [
                  Container(
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
                                          builder: (context) =>
                                              EditPetProfileScreen(petProfile: pet),
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
                              Text('BREED: ${pet.breed}', style: PetProfileStyles.petInfoTextStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFBBDEFB),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Health Advice',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Delicious food: On lazy days, training your cat to be happy indoors...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Other Tips: Choose premium dry cat food for indoor cats...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 30,
                      childAspectRatio: 1,
                      children: [
                        _buildVaccinationMainCard(
                          context,
                          title: 'VACCINE PET\'S',
                          icon: Icons.vaccines,
                          color: const Color(0xFFE09492),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/vaccinepet',
                              arguments: {
                                'petsId': petsId,
                                'name': pet.name,
                                'image': imagePath,
                              },
                            );
                          },
                        ),
                        _buildVaccinationMainCard(
                          context,
                          title: 'Check History',
                          icon: Icons.history,
                          color: const Color(0xFF72C1A3),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/historyrec',
                              arguments: {
                                'petsId': petsId,
                                'name': pet.name,
                                'image': imagePath,
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No pet data available'));
          }
        },
      ),
    );
  }

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

  Widget _buildVaccinationMainCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius:
              BorderRadius.circular(10), // Added border radius for better UI
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
