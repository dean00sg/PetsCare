import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/pet_bloc.dart';
import 'package:frontend/bloc/pet_event.dart';
import 'package:frontend/bloc/pet_state.dart';
import 'package:frontend/styles/pet_style.dart';

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
      body: BlocProvider(
        create: (context) => PetBloc()..add(LoadPets()),
        child: BlocBuilder<PetBloc, PetState>(
          builder: (context, state) {
            if (state is PetLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PetLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 30,
                    childAspectRatio: 4 / 4,
                  ),
                  itemCount: state.pets.length,
                  itemBuilder: (context, index) {
                    final pet = state.pets[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/create_pet',
                          arguments: pet, // ส่งข้อมูล Pet ไปยังหน้า CreatePetScreen
                        );
                      },
                      child: Container(
                        decoration: petContainerDecoration, // ใช้ Style จาก pet_style.dart
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(pet.imagePath),
                              backgroundColor: Colors.grey[300],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pet.name,
                              style: petNameStyle, // ใช้ Style จาก pet_style.dart
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is PetError) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: Text('No pets available.'));
            }
          },
        ),
      ),
    );
  }
}
