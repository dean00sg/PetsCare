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
              child: SingleChildScrollView( 
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
                                  '${pet.birthDate}, Age: ${petAge['years'] != 0 ? '${petAge['years']} Y ' : ''}${petAge['months'] != 0 ? '${petAge['months']} M ' : ''}${petAge['days'] != 0 ? '${petAge['days']} D' : ''}',       // แสดงวันถ้ามากกว่า 0
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
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: PetProfileStyles.boxDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: const Color(0xFF3574D8),
                            padding: const EdgeInsets.all(16.0),
                            child: const Center(
                              child: Text(
                                'Health Advice',
                                style: PetProfileStyles.healthAdviceTitleStyle, 
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Builder(
                            builder: (context) {
                              // ดึงข้อมูลที่ตรงตามเงื่อนไข
                              final healthRecords = state.healthRecords.where((record) {
                                final petYears = petAge['years'] ?? 0;
                                final petMonths = petAge['months'] ?? 0;
                                final petDays = petAge['days'] ?? 0;
                                final petWeight = pet.weight;

                                final startAgeCheck = petYears > record.age.years ||
                                    (petYears == record.age.years && petMonths > record.age.months) ||
                                    (petYears == record.age.years && petMonths == record.age.months && petDays >= record.age.days);

                                final endAgeCheck = petYears < record.toAge.years ||
                                    (petYears == record.toAge.years && petMonths < record.toAge.months) ||
                                    (petYears == record.toAge.years && petMonths == record.toAge.months && petDays <= record.toAge.days);

                                final weightCheck = petWeight >= record.weightStartMonths &&
                                    petWeight <= record.weightEndMonths;

                                return startAgeCheck && endAgeCheck && weightCheck;
                              }).toList(); // เปลี่ยนเป็น List เพื่อเช็คว่ามีข้อมูลหรือไม่

                              // ตรวจสอบว่า healthRecords ว่างหรือไม่
                              if (healthRecords.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No health advice available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF616161),
                                    ),
                                  ),
                                );
                              }

                              // ถ้ามีข้อมูลที่ตรงตามเงื่อนไข แสดงข้อมูลนั้น
                              return Column(
                                children: healthRecords.map((record) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: const Color(0xFF6496E6),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Header : ${record.header}',
                                              style: PetProfileStyles.headerTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: Colors.teal[300],
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Age: ${record.age.years > 0 ? '${record.age.years}Y ' : ''}${record.age.months > 0 ? '${record.age.months}M ' : ''} - ${record.toAge.years > 0 ? '${record.toAge.years}Y ' : ''}${record.toAge.months > 0 ? '${record.toAge.months}M ' : ''}',
                                              style: PetProfileStyles.ageAndWeightTextStyle, 
                                            ),
                                            Text(
                                              'Weight: ${record.weightStartMonths} - ${record.weightEndMonths}kg',
                                              style: PetProfileStyles.ageAndWeightTextStyle, 
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 150,
                                        width: double.infinity,
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(8),
                                        child: SingleChildScrollView(
                                          child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Advice: ',
                                                    style: PetProfileStyles.adviceTextStyleBold,
                                                  ),
                                                  TextSpan(
                                                    text: record.description,
                                                    style: PetProfileStyles.adviceTextStyle,
                                                  ),
                                                ],
                                              ),
                                              overflow: TextOverflow.visible, 
                                            ),
                                          ),
                                        ),

                                    ],
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4, 
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
              ),
            );
          }
          return const Center(child: Text('No Data'));
        },
      ),
    );
  }

  Map<String, int> calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) {
      years--;
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
          borderRadius: BorderRadius.circular(10), 
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), 
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
