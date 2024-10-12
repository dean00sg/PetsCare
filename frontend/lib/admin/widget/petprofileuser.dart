import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/petprofileuser.dart';
import 'package:frontend/admin/event/petprofileuser.dart';
import 'package:frontend/admin/models/petprofileuser.dart';
import 'package:frontend/admin/repositories/petprofileuser.dart';
import 'package:frontend/admin/state/petprofileuser.dart';
import '../style/petprofile_style.dart';
import '../appbar/search_bar.dart';

class PetProfileUserScreen extends StatefulWidget {
  const PetProfileUserScreen({super.key});

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileUserScreen> {
  String _searchQuery = ''; //ตัวแปรสำหรับเก็บค่าการค้นหา

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PetProfileUserBloc(PetProfileUserRepository())..add(FetchPetsEvent()),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Owner with Pets',
              style: TextStyle(fontSize: 22, color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 38, 111, 202),
          centerTitle: true,
          toolbarHeight: 70,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 25, top: 16), 
                  child: Text(
                    'User with Pets',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(38, 50, 56, 1),
                    ),
                  ),
                ),
              ),
              CustomSearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase(); //อัปเดตการค้นหา
                  });
                },
              ),
              Expanded(
                child: BlocBuilder<PetProfileUserBloc, PetProfileUserState>(
                  builder: (context, state) {
                    if (state is PetLoadingUserState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PetLoadedUserState) {
                      if (state.pets.isEmpty) {
                        return const Center(child: Text('No pets available.'));
                      }

                      // Group pets by owner
                      final Map<String, List<PetProfileUserModel>> ownerPetsMap = {};
                      for (var pet in state.pets) {
                        ownerPetsMap.putIfAbsent(pet.owner_name, () => []).add(pet);
                      }

                      //กรองผลลัพธ์ตาม search query (ค้นหาทั้งข้อมูลเจ้าของและสัตว์เลี้ยง)
                      final filteredOwnerPetsMap = ownerPetsMap.entries.where((entry) {
                        final ownerName = entry.key.toLowerCase();
                        final filteredPets = entry.value.where((pet) {
                          //ค้นหาทั้งหมดในข้อมูลสัตว์เลี้ยง
                          return ownerName.contains(_searchQuery) ||
                                 pet.name.toLowerCase().contains(_searchQuery) ||
                                 pet.type_pets.toLowerCase().contains(_searchQuery) ||
                                 pet.breed.toLowerCase().contains(_searchQuery) ||
                                 pet.birth_date.toString().contains(_searchQuery) ||
                                 pet.weight.toString().contains(_searchQuery);
                        }).toList();
                        return filteredPets.isNotEmpty || ownerName.contains(_searchQuery);
                      }).toList();

                      //จัดเรียงสัตว์เลี้ยงที่ตรงกับการค้นหาขึ้นด้านบน
                      filteredOwnerPetsMap.sort((a, b) {
                        final aContainsQuery = a.value.any((pet) =>
                            pet.name.toLowerCase().contains(_searchQuery) ||
                            pet.type_pets.toLowerCase().contains(_searchQuery) ||
                            pet.breed.toLowerCase().contains(_searchQuery));
                        
                        final bContainsQuery = b.value.any((pet) =>
                            pet.name.toLowerCase().contains(_searchQuery) ||
                            pet.type_pets.toLowerCase().contains(_searchQuery) ||
                            pet.breed.toLowerCase().contains(_searchQuery));
                        
                        //แปลง bool เป็น int (true = 1, false = 0) แล้วนำมาเปรียบเทียบ
                        return bContainsQuery ? 1 : 0 - (aContainsQuery ? 1 : 0);
                      });

                      return ListView(
                        children: [
                          ...filteredOwnerPetsMap.map((entry) {
                            final ownerName = entry.key;
                            final pets = entry.value;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                              decoration: AppStyles.userContainerDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    const CircleAvatar(
                                      radius: 40,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      ownerName,
                                      style: AppStyles.userNameTextStyle,
                                    ),
                                    Column(
                                      children: pets.map((pet) {
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          child: Container(
                                            decoration: AppStyles.petCardDecoration,
                                            constraints: const BoxConstraints(
                                              maxWidth: 320,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: Colors.white,
                                                        child: Image.asset(
                                                          PetTypeImage.getImagePath(pet.type_pets),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Text(
                                                        pet.name,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey[800],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  _buildPetInfoRowWithBorder('typepets', pet.type_pets),
                                                  _buildPetInfoRowWithBorder('sex', pet.sex),
                                                  _buildPetInfoRowWithBorder('breed', pet.breed),
                                                  _buildPetInfoRowWithBorder('birthdate', pet.birth_date),
                                                  _buildPetInfoRowWithBorder('weight', '${pet.weight}kg'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    } else if (state is PetErrorUserState) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const Center(child: Text('No pets found.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างแถวข้อมูลสัตว์เลี้ยงแต่ละบรรทัด
  Widget _buildPetInfoRowWithBorder(String label, String value) {
    return Padding(
      padding: AppStyles.petInfoMargin,
      child: Container(
        decoration: AppStyles.petInfoBoxDecoration,
        padding: AppStyles.petInfoPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label : ',
              style: AppStyles.petLabelTextStyle,
            ),
            Text(
              value,
              style: AppStyles.petValueTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
