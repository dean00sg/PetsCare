import 'package:flutter/material.dart';
import 'package:frontend/users/models/petslidebar_models.dart';
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
    futurePets = petRepository.fetchPets();
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
              decoration: BoxDecoration(color: Colors.brown),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 25),
            _buildDrawerItem(
              title: 'HOME',
              route: '/feed',
              isCurrentRoute: currentRoute == '/feed',
            ),
            const SizedBox(height: 15),
            _buildDrawerItem(
              title: 'NEW PETS',
              route: '/createpetsmain',
              isCurrentRoute: currentRoute == '/createpetsmain',
            ),
            const SizedBox(height: 15),
            _buildPetsExpansionTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required String title, required String route, required bool isCurrentRoute}) {
    return Visibility(
      visible: !isCurrentRoute,
      child: Container(
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
        child: ListTile(
          title: Text(title, style: const TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
        ),
      ),
    );
  }

  Widget _buildPetsExpansionTile() {
    return FutureBuilder<List<Pet>>(
      future: futurePets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.brown)));
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
            title: const Text('MY PETS', style: TextStyle(color: Colors.white)),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            children: pets.map((pet) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/petsprofile', arguments: {
                    'petsId': pet.petsId,
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        pet.imagePath,
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        pet.name,
                        style: const TextStyle(color: Colors.brown, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
