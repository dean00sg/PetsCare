import 'dart:io'; // Import สำหรับจัดการไฟล์
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // ใช้สำหรับเลือกไฟล์จากโฟลเดอร์
//import 'package:frontend/users/bloc/create_pet_bloc.dart';
//import 'package:frontend/users/bloc/create_pet_event.dart';
import 'package:frontend/users/models/create_pet_model.dart';
import 'package:frontend/users/models/pet_models.dart';
import 'package:frontend/users/styles/create_pet_style.dart';
import 'package:frontend/users/widget_screen/pet_details_screen.dart';

class CreatePetScreen extends StatefulWidget {
  final Pet pet; // รับพารามิเตอร์ pet จากหน้า PetScreen

  const CreatePetScreen({super.key, required this.pet});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePetScreenState createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends State<CreatePetScreen> {
  // ตัวแปรควบคุมการอัปโหลดรูปภาพใหม่
  File? _image;
  final picker = ImagePicker();

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

  // ฟังก์ชันสำหรับอัปโหลดรูปภาพใหม่
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // เก็บไฟล์รูปภาพใหม่ที่เลือก
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text(
          'CREATE MY ${widget.pet.name.toUpperCase()}',
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
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundImage: _image != null
                            ? FileImage(_image!) // แสดงรูปที่อัปโหลดใหม่
                            : AssetImage(widget.pet.imagePath) as ImageProvider, // แสดงรูปเริ่มต้นจากหน้า PetScreen
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
                  const SizedBox(height: 30),
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
                        // ถ้าไม่ได้อัปโหลดรูปใหม่ ให้ใช้รูปเริ่มต้น
                        imagePath: _image != null ? _image!.path : widget.pet.imagePath,
                      );

                      // ส่งข้อมูลไปยังหน้า PetDetailsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailsScreen(pet: petData),
                        ),
                      );
                    },
                    child: const Text('SAVE', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
