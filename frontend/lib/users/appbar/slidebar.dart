

// import 'package:flutter/material.dart';

// class Sidebar extends StatelessWidget {
//   const Sidebar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: Colors.white,
//         child: ListView(
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.brown,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             // ใช้ Container ครอบ ListTile แต่ละอัน
//             const SizedBox(height: 25),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 color: Colors.brown, 
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ], 
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: const Text('Feed', style: TextStyle(color: Colors.white)),
//                     onTap: () {
//                       Navigator.pushNamed(context, '/feed');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 15),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 8.0),
//               decoration: BoxDecoration(
//                 color: Colors.brown, 
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ], 
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: const Text('PETS', style: TextStyle(color: Colors.white)),
//                     onTap: () {
//                       Navigator.pushNamed(context, '/createpetsmain');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 15),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 8.0),
//               decoration: BoxDecoration(
//                 color: Colors.brown, 
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ], 
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: const Text('My Pets', style: TextStyle(color: Colors.white)),
//                     onTap: () {
//                       Navigator.pushNamed(context, '/');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//โค้ดด้านล่างจะโชว์สัตว์เลี้ยงของตัวเอง  ข้างบน จะเป็นโค้ดเก่า



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
            _buildFeedTile(),
            const SizedBox(height: 15),
            _buildPetsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTile() {
    return Container(
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
            title: const Text('Feed', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushNamed(context, '/feed');
            },
          ),
        ],
        
      ),
      
    );
  }

  Widget _buildPetsList() {
    return FutureBuilder<List<Pet>>(
      future: futurePets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No pets found'));
        }

        final pets = snapshot.data!;

        return Column(
          children: pets.map((pet) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
                leading: Image.asset(pet.imagePath), // Display pet image from assets
                title: Text(pet.name, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  // Handle navigation or actions for each pet
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
