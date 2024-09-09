import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart';
import 'package:frontend/users/bloc/create_pet_event.dart';
import 'package:frontend/users/models/create_pet_model.dart';
import 'package:frontend/users/widget_screen/edit_profile_pet.dart';
import 'package:intl/intl.dart';

class PetDetailsScreen extends StatelessWidget {
  final PetModel pet;

  // ignore: use_super_parameters
  const PetDetailsScreen({Key? key, required this.pet}) : super(key: key);

  // ฟังก์ชันคำนวณอายุในหน่วยปี เดือน วัน
  Map<String, int> calculateAge(String birthDateString) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birthDateString);
    DateTime currentDate = DateTime.now();

    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    int days = currentDate.day - birthDate.day;

    if (days < 0) {
      months--;
      days += DateTime(currentDate.year, currentDate.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> petAge = calculateAge(pet.dateOfBirth);

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name, style: const TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: Colors.brown[400],
        centerTitle: true,
        actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.account_circle),
              onSelected: (String result) {
                if (result == 'profile') {
                  Navigator.pushNamed(context, '/profile');
                } else if (result == 'signout') {
                  Navigator.pushNamed(context, '/');
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('PROFILE'),
                ),
                const PopupMenuItem<String>(
                  value: 'signout',
                  child: Text('SIGN OUT'),
                ),
              ],
            ),
          ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown[400],
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('HOME'),
              onTap: () {
                Navigator.pushNamed(context, '/feed');
              },
            ),
            ListTile(
              title: const Text('PETS'),
              onTap: () {
                Navigator.pushNamed(context, '/pet');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 400,
              height: 250,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.brown, // กำหนดพื้นหลังสีน้ำตาลอ่อน
                borderRadius: BorderRadius.circular(16), // เพิ่มความโค้งที่มุม
                              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูปสัตว์เลี้ยง
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 193, 193, 193),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/images/cat_icon.png', // แสดงรูปภาพจาก assets
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // ข้อมูลสัตว์เลี้ยง
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.sex},',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Age: ${petAge['years']}y ${petAge['months']}m  ${petAge['days']}d',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weight: ${pet.weight}kg.',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Breed: ${pet.breed}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[100],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                    onPressed: () async {
                      final updatedPet = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPetScreen(pet: pet),
                        ),
                      );
                      if (updatedPet != null) {
                        // ignore: use_build_context_synchronously
                        BlocProvider.of<CreatePetBloc>(context).add(UpdatePetProfile(updatedPet));
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างคอนเทนเนอร์


            // คอนเทนเนอร์แสดงกราฟ
            Container(
              width: 400,
              height: 300,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.brown[300],
                borderRadius: BorderRadius.circular(16), // เพิ่มขอบโค้งให้กราฟ
              ),
              // child: LineChart(
              //   LineChartData(
              //     borderData: FlBorderData(show: true),
              //     lineBarsData: [
              //       LineChartBarData(
              //         spots: const [
              //           FlSpot(0, 1),
              //           FlSpot(1, 1.5),
              //           FlSpot(2, 2.4),
              //           FlSpot(3, 2.8),
              //           FlSpot(4, 3.2),
              //           FlSpot(5, 3.6),
              //           FlSpot(6, 4.0),
              //         ],
              //         isCurved: true,
              //         colors: [Colors.brown],
              //         barWidth: 4,
              //         isStrokeCapRound: true,
              //         dotData: FlDotData(show: true),
              //         belowBarData: BarAreaData(
              //           show: true,
              //           colors: [Colors.brown.withOpacity(0.3)],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
