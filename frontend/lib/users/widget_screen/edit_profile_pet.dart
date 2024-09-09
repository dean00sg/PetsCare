import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart';
import 'package:frontend/users/bloc/create_pet_state.dart';
import 'package:frontend/users/models/create_pet_model.dart';
import 'package:frontend/users/styles/create_pet_style.dart';

class EditPetScreen extends StatefulWidget {
  final PetModel pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  // ignore: library_private_types_in_public_api
  _EditPetScreenState createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  // TextEditingController สำหรับแต่ละฟิลด์
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  String? _selectedSex;

  @override
  void initState() {
    super.initState();
    // ตั้งค่าให้ TextEditingController เริ่มต้นด้วยข้อมูลจากสัตว์เลี้ยงที่ต้องการแก้ไข
    _nameController.text = widget.pet.name;
    _dateController.text = widget.pet.dateOfBirth;
    _weightController.text = widget.pet.weight;
    _breedController.text = widget.pet.breed;
    _selectedSex = widget.pet.sex;
  }

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
    return BlocProvider(
      create: (_) => CreatePetBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: const Text(
            'EDIT PET PROFILE',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          centerTitle: true,
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
                decoration: containerDecoration, // ใช้สไตล์จาก create_pet_style.dart
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
                          'lib/images/cat_icon.png', // แสดงรูปภาพจาก assets
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                              style: saveButtonStyle, // ใช้สไตล์ปุ่มจาก create_pet_style.dart
                              onPressed: () {
                                final updatedPet = PetModel(
                                  name: _nameController.text,
                                  dateOfBirth: _dateController.text,
                                  weight: _weightController.text,
                                  sex: _selectedSex!,
                                  breed: _breedController.text,
                                );

                                // ส่งข้อมูลกลับไปยังหน้า PetDetailsScreen
                                Navigator.pop(context, updatedPet);
                              },
                              child: const Text('SAVE', style: TextStyle(fontSize: 16)),
                            ),
                            BlocListener<CreatePetBloc, CreatePetState>(
                              listener: (context, state) {
                                if (state is CreatePetUpdatedSuccess) {
                                  Navigator.pop(context, state.updatedPet);
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
