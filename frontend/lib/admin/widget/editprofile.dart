import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/style/profile.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/models/profile_model.dart';

class EditProfileAdminScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileAdminScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _phone;

  @override
  void initState() {
    super.initState();
    _firstName = widget.profile.firstName;
    _lastName = widget.profile.lastName;
    _email = widget.profile.email;
    _phone = widget.profile.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Profile', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 111, 202), 
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Center(
        child: Container( //ปรับขนาดของ container
          width: 320, 
          height: 680, 
          padding: const EdgeInsets.all(20.0),
          decoration: profileContainerDecoration,
          child: SingleChildScrollView( //SingleChildScrollView ป้องกันการล้นของหน้าจอ
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Icon
                  profileAvatarDecoration,
                  const SizedBox(height: 20),

                  // Profile Title
                  const Text('PROFILE ADMIN', style: titleStyle),
                  const SizedBox(height: 20),

                  //First Name
                  Container(
                    padding: containerPadding,
                    decoration: containerDecoration,
                    child: TextFormField(
                      initialValue: _firstName,
                      style: const TextStyle(color: Colors.white), 
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      onSaved: (value) {
                        _firstName = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  //Last Name
                  Container(
                    padding: containerPadding,
                    decoration: containerDecoration,
                    child: TextFormField(
                      initialValue: _lastName,
                      style: const TextStyle(color: Colors.white), 
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.white), 
                      ),
                      onSaved: (value) {
                        _lastName = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  //Email (ไม่สามารถแก้ไขได้)
                  Container(
                    padding: containerPadding,
                    decoration: containerDecoration,
                    child: TextFormField(
                      initialValue: _email,
                      style: const TextStyle(color: Colors.white), 
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.white), 
                      ),
                      enabled: false, // ปิดการแก้ไขช่องกรอกนี้
                    ),
                  ),
                  const SizedBox(height: 12),

                  //Phone
                  Container(
                    padding: containerPadding,
                    decoration: containerDecoration,
                    child: TextFormField(
                      initialValue: _phone,
                      style: const TextStyle(color: Colors.white), 
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.white), 
                      ),
                      onSaved: (value) {
                        _phone = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ปุ่ม Save
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: editButtonStyle,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final updatedProfile = UserProfile(
                            firstName: _firstName,
                            lastName: _lastName,
                            email: _email,
                            phone: _phone,
                          );
                          // อัปเดตโปรไฟล์โดยใช้ Bloc
                          context.read<ProfileBloc>().updateProfile(updatedProfile);
                          Navigator.pop(context, true); 
                        }
                      },
                      child: const Text('Save', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
