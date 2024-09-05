import 'package:flutter/material.dart';


class Pet {
  final String name;
  final String imagePath;

  Pet({required this.name, required this.imagePath});
}

final List<Pet> pets = [
  Pet(name: 'Cat', imagePath: 'lib/images/cat_icon.png'),
  Pet(name: 'Dog', imagePath: 'lib/images/dog_icon.png'),
  Pet(name: 'Rabbit', imagePath: 'lib/images/rabbit_icon.png'),
  Pet(name: 'Fish', imagePath: 'lib/images/fish_icon.png'),
];

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PETS', style: TextStyle(fontSize: 16, color: Colors.white)),
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50), // เพิ่ม Padding รอบ GridView
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // แสดง 2 pet ต่อแถว
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            childAspectRatio: 4/4, // กำหนดสัดส่วนของแต่ละ item
          ),
          itemCount: pets.length,
          itemBuilder: (context, index) {
            final pet = pets[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/create_pet');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown[500],
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // ทำให้เกิดเงา
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(pet.imagePath), // โหลดรูปจาก assets
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pet.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}