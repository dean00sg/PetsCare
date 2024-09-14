import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart';
import 'package:frontend/users/event/create_pet_event.dart';
import 'package:frontend/users/models/create_pet_model.dart';
import 'package:frontend/users/styles/create_pet_style.dart';
import 'package:image_picker/image_picker.dart';

class EditPetScreen extends StatefulWidget {
  final PetModel pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  // ignore: library_private_types_in_public_api
  _EditPetScreenState createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _weightController;
  late TextEditingController _breedController;
  String? _selectedSex;
  File? _image; // ตัวแปรสำหรับเก็บรูปภาพที่อัปโหลดใหม่
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _dateController = TextEditingController(text: widget.pet.dateOfBirth);
    _weightController = TextEditingController(text: widget.pet.weight);
    _breedController = TextEditingController(text: widget.pet.breed);
    _selectedSex = widget.pet.sex;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // เก็บไฟล์รูปภาพใหม่ที่เลือก
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PORFILE', style: TextStyle(fontSize: 16, color: Colors.white),),
        backgroundColor: Colors.brown[400],
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 750,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.all(16.0),
          decoration: containerDecoration, // ใช้สไตล์จาก create_pet_style.dart
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 90,
                            backgroundImage: _image != null
                                ? FileImage(_image!) // แสดงรูปที่อัปโหลดใหม่
                                : AssetImage(widget.pet.imagePath!) as ImageProvider, 
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.7),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      ElevatedButton(
                        style: saveButtonStyle,
                        onPressed: () {
                          final updatedPet = PetModel(
                            name: _nameController.text,
                            dateOfBirth: _dateController.text,
                            weight: _weightController.text,
                            sex: _selectedSex!,
                            breed: _breedController.text, imagePath: '',
                          );

                          BlocProvider.of<CreatePetBloc>(context)
                              .add(UpdatePetProfile(updatedPet));

                          Navigator.pop(context, updatedPet);
                        },
                        child: const Text('SAVE', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







