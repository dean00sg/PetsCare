import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/appbar/navbar.dart';
import 'package:frontend/users/appbar/slidebar.dart';
import 'package:frontend/users/bloc/pet_bloc.dart';
import 'package:frontend/users/event/pet_event.dart';
import 'package:frontend/users/state/pet_state.dart';
import 'package:frontend/users/styles/pet_style.dart';

class PetSMaincreen extends StatelessWidget {
  const PetSMaincreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(), 
      drawer: const Sidebar(), 
      body: BlocProvider(
        create: (context) => PetBloc()..add(LoadPets()),
        child: BlocBuilder<PetBloc, PetState>(
          builder: (context, state) {
            if (state is PetLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PetLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TYPE PETS',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900],
                      ),
                    ),
                    const SizedBox(height: 20), // ระยะห่างระหว่างข้อความและ GridView
                    Expanded( // ใช้ Expanded เพื่อให้ GridView ครอบคลุมพื้นที่ที่เหลืออยู่
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
                                '/createpets',
                                arguments: {
                                  'name': pet.name,     
                                  'imagePath': pet.imagePath, 
                                },
                              );
                            },
                            child: Container(
                              decoration: petContainerDecoration,
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
                                    style: petNameStyle,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
