import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/create_pet_bloc.dart';
import 'package:frontend/bloc/create_pet_event.dart';
import 'package:frontend/bloc/create_pet_state.dart';
import 'package:frontend/models/create_pat_model.dart';
import 'package:frontend/styles/create_pet_style.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<CreatePetScreen> {
  // TextEditingController สำหรับแต่ละฟิลด์
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  String? _selectedSex; // ค่าเพศที่เลือกเริ่มต้นเป็น null

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
          title: const Text('CREATE MY PET', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                decoration: containerDecoration, // ใช้ Style Container ที่แยกออกมา
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color.fromARGB(255, 193, 193, 193), width: 8), // ทำให้ Container มีรูปร่างเป็นวงกลม
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'lib/images/cat_icon.png',
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    const Text(
                      'PET PROFILE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            // Name Field
                            TextField(
                              controller: _nameController,
                              decoration: inputDecoration('Name'), // ใช้ Style TextField ที่แยกออกมา
                            ),
                            const SizedBox(height: 25),
                            // Date of Birth Field
                            TextField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: inputDecoration('Date of Birth'),
                              onTap: () {
                                _selectDate(context); // แสดง date picker เมื่อกด TextField
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
                              style: saveButtonStyle, // ใช้ Style ปุ่มที่แยกออกมา
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
