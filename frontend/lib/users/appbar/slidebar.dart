import 'package:flutter/material.dart';
import 'package:frontend/users/models/pet_models.dart';
import 'package:frontend/users/repositories/pets_repository.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late Future<List<Pet>> futurePets;
  final CreatePetRepository petRepository = CreatePetRepository();

  @override
  void initState() {
    super.initState();
    futurePets = petRepository.fetchPets(); // Fetch pets on initialization
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 25),
            if (currentRoute != '/feed') 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.brown, 
                borderRadius: BorderRadius.circular(4),
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
                children: [
                  ListTile(
                    title: const Text('HOME', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/feed');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (currentRoute != '/createpetsmain')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.brown, 
                borderRadius: BorderRadius.circular(4),
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
                children: [
                  ListTile(
                    title: const Text('TYPE PETS', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/createpetsmain');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // MY PETS Container with ExpansionTile
            FutureBuilder<List<Pet>>(
              future: futurePets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No pets found', style: TextStyle(color: Colors.brown)));
                }

                final pets = snapshot.data!;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    title: const Text(
                      'MY PETS',
                      style: TextStyle(color: Colors.white),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: pets.map((pet) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.brown[50], 
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              pet.imagePath,
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              pet.name,
                              style: const TextStyle(color: Colors.brown),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
