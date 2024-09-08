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
        title: Text(pet.name, style: const TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: Colors.brown[400],
        centerTitle: true,
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
        child: Container(
          width: 400,
          height: 280,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.brown, 
            borderRadius: BorderRadius.circular(16), 
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Align(
                alignment: Alignment.center, // จัดให้อยู่ตรงกลาง
                child: Container(
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
                      'lib/images/cat_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              // ข้อมูลสัตว์เลี้ยง
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
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
                      ' Age: ${petAge['years']}y ${petAge['months']}m  ${petAge['days']}d',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.sex}, Weight: ${pet.weight}kg.',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Breed: ${pet.breed}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // นำไปหน้าแก้ไขสัตว์เลี้ยง
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditPetScreen(pet: pet), // หน้าสำหรับแก้ไขสัตว์เลี้ยง
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
