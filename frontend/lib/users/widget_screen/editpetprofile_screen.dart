import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/petprofile.dart';
import 'package:frontend/users/event/petprofile.dart';
import 'package:frontend/users/models/petprofile.dart';
import 'package:frontend/users/styles/editpetprofile_style.dart'; 

class EditPetProfileScreen extends StatefulWidget {
  final PetProfile petProfile;

  const EditPetProfileScreen({Key? key, required this.petProfile}) : super(key: key);

  @override
  _EditPetProfileScreenState createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String _birthDate;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.petProfile.name;
    _birthDate = widget.petProfile.birthDate;
    _weightController.text = widget.petProfile.weight.toString();
    _imagePath = PetTypeImage.getImagePath(widget.petProfile.typePets);
    _birthDateController.text = _birthDate;
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Pet Profile', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.brown,
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'MY ${widget.petProfile.typePets.toUpperCase()}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900], 
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: profileContainerDecoration,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(_imagePath),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'PROFILE',
                        style: profileTextStyle, 
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Name :', 
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: inputDecoration.copyWith(),
                        onSaved: (value) {
                          _nameController.text = value!;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Birth Date
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Date of Birth :', 
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      TextFormField(
                        controller: _birthDateController,
                        decoration: inputDecoration.copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(_birthDate),
                            firstDate: DateTime(1900), 
                            lastDate: DateTime.now(), 
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _birthDate = pickedDate.toIso8601String().split('T').first; // แปลงวันที่ที่เลือกให้เป็นรูปแบบที่ต้องการ
                              _birthDateController.text = _birthDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Weight
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Weight :', 
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      TextFormField(
                        controller: _weightController,
                        decoration: inputDecoration.copyWith(),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _weightController.text = value!;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: saveButtonStyle,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final updatedPetProfile = PetProfile(
                                status: widget.petProfile.status,
                                petsId: widget.petProfile.petsId,
                                name: _nameController.text,
                                typePets: widget.petProfile.typePets,
                                sex: widget.petProfile.sex,
                                breed: widget.petProfile.breed,
                                birthDate: _birthDate,
                                weight: double.parse(_weightController.text),
                                userId: widget.petProfile.userId,
                                ownerName: widget.petProfile.ownerName,
                              );

                              // ใช้ Bloc เพื่ออัปเดตโปรไฟล์
                              BlocProvider.of<PetProfileBloc>(context).add(UpdatePetProfile(updatedPetProfile));
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
