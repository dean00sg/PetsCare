import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/create_pet_bloc.dart';
import 'package:frontend/bloc/create_pet_event.dart';
import 'package:frontend/bloc/create_pet_state.dart';
import 'package:frontend/models/create_pat_model.dart';
import 'package:frontend/models/pet_models.dart';
import 'package:frontend/styles/create_pet_style.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePetScreenState createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends State<CreatePetScreen> {
  // TextEditingController สำหรับแต่ละฟิลด์
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  String? _selectedSex;

  // ฟังก์ชันแสดง DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // รับข้อมูล Pet จาก arguments ที่ถูกส่งมา
    final Pet pet = ModalRoute.of(context)?.settings.arguments as Pet;

    return BlocProvider(
      create: (_) => CreatePetBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: Text(
            'CREATE MY ${pet.name.toUpperCase()}', // ใช้ชื่อ pet ใน title ของ AppBar
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
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
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 500,
                height: 750,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: containerDecoration, 
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    // แสดงรูปภาพของสัตว์ที่เลือก
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
                          pet.imagePath, // แสดงรูปภาพตามสัตว์ที่เลือก
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // แสดงชื่อสัตว์ที่เลือก
                    Text(
                      '${pet.name.toUpperCase()} PROFILE', // ชื่อสัตว์ที่เลือก
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ฟิลด์สำหรับกรอกข้อมูล
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            // Name Field
                            TextField(
                              controller: _nameController,
                              decoration: inputDecoration('Name'),
                            ),
                            const SizedBox(height: 25),
                            // Date of Birth Field
                            TextField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: inputDecoration('Date of Birth'),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                            const SizedBox(height: 25),
                            // Weight Field
                            TextField(
                              controller: _weightController,
                              decoration: inputDecoration('Weight'),
                            ),
                            const SizedBox(height: 25),
                            // Sex Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedSex,
                              decoration: inputDecoration('Sex'),
                              hint: const Text('Sex'),
                              items: <String>['Male', 'Female'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedSex = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 25),
                            // Breed Field
                            TextField(
                              controller: _breedController,
                              decoration: inputDecoration('Breed'),
                            ),
                            const SizedBox(height: 30),
                            // Save Button
                            ElevatedButton(
                              style: saveButtonStyle, 
                              onPressed: () {
                                final petData = PetModel(
                                  name: _nameController.text,
                                  dateOfBirth: _dateController.text,
                                  weight: _weightController.text,
                                  sex: _selectedSex!,
                                  breed: _breedController.text,
                                );
                                BlocProvider.of<CreatePetBloc>(context).add(
                                  SavePetProfile(petData),
                                );
                              },
                              child: const Text('SAVE', style: TextStyle(fontSize: 16)),
                            ),
                            BlocListener<CreatePetBloc, CreatePetState>(
                              listener: (context, state) {
                                if (state is CreatePetSuccess) {
                                  Navigator.pushNamed(context, '/pet_list');
                                } else if (state is CreatePetFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.error)),
                                  );
                                }
                              },
                              child: BlocBuilder<CreatePetBloc, CreatePetState>(
                                builder: (context, state) {
                                  if (state is CreatePetLoading) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
