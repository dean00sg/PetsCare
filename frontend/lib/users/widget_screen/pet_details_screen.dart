import 'package:flutter/material.dart';
import 'package:frontend/users/models/create_pet_model.dart';
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
        title: Text(pet.name), 
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white, 
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color.fromARGB(255, 193, 193, 193), width: 8),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'lib/images/cat_icon.png', // แสดงรูปภาพจาก assets
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            Text(
              pet.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              pet.dateOfBirth,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              'Age: ${petAge['years']} y ${petAge['months']} m ${petAge['days']} d',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              'Weigh: ${pet.weight} kg',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              'Sex: ${pet.sex}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              'Breed: ${pet.breed}',
              style: const TextStyle(fontSize: 20),
            ),          
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // กลับไปยังหน้าเดิม
              },
              child: const Text('กลับ'),
            ),
          ],
        ),
      ),
    );
  }
}
