import 'package:flutter/material.dart';
import 'package:frontend/users/styles/signup_style.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:frontend/users/models/signup_model.dart';

class EditProfileScreen extends StatefulWidget {
  final SignupModel userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  File? _profileImage; // เก็บรูปโปรไฟล์ใหม่

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.userData.firstName);
    _lastNameController = TextEditingController(text: widget.userData.lastName);
    _emailController = TextEditingController(text: widget.userData.email);
    _phoneController = TextEditingController(text: widget.userData.phone);
    _passwordController = TextEditingController(text: widget.userData.password);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ฟังก์ชันสำหรับเลือกโปรไฟล์รูปจากแกลเลอรี
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('EDIT PROFILE', style: TextStyle(fontSize: 16, color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: containerDecoration, // ใช้สีพื้นหลังตามสไตล์
            height: 600,
            width: 320, // ปรับขนาดของ Container ให้เหมาะสมกับหน้าจอมือถือ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('lib/images/logo.png') as ImageProvider,
                    child: const Icon(Icons.camera_alt, size: 30),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _firstNameController,
                  decoration: inputDecoration('First Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: inputDecoration('Last Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: inputDecoration('Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: inputDecoration('Phone'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: inputDecoration('New Password'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: signUpButtonStyle,
                  onPressed: () {
                    final updatedUserData = SignupModel(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      phone: _phoneController.text,
                    );

                    Navigator.pop(context, {
                      'userData': updatedUserData,
                      'profileImage': _profileImage,
                    });
                  },
                  child: const Text('SAVE', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
