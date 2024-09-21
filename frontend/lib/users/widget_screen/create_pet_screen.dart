import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart';
import 'package:frontend/users/event/create_pet_event.dart';
import 'package:frontend/users/models/create_pet_model.dart';
import 'package:frontend/users/state/create_pet_state.dart';
import 'package:frontend/users/styles/create_pet_style.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({super.key});

  @override
  _CreatePetScreenState createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends State<CreatePetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _petTypeController = TextEditingController();
  String? _selectedSex;
  String? _imagePath;

  Map<String, dynamic>? args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _petTypeController.text = args!['name'];  // Set type of pet
      _imagePath = args!['imagePath'];
    }
  }

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

  void _submitForm(BuildContext context) {
    final double weight = double.tryParse(_weightController.text) ?? 0;

    final pet = PetModel(
      name: _nameController.text,
      dateOfBirth: _dateController.text,  // 'birth_date'
      weight: weight,
      sex: _selectedSex!,
      breed: _breedController.text,
      typePets: _petTypeController.text,  // 'type_pets'
      imagePath: _imagePath ?? '',        // Optional imagePath
    );

    BlocProvider.of<CreatePetBloc>(context).add(SavePetProfile(pet));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile',
          style: TextStyle(fontSize: 22, color: Colors.white),),
        backgroundColor: Colors.brown,
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: BlocListener<CreatePetBloc, CreatePetState>(
        listener: (context, state) {
          if (state is CreatePetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pet created successfully!")),
            );
            Navigator.of(context).pop();
          } else if (state is CreatePetFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to create pet: ${state.error}")),
            );
          }
        },
        
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'MY ${args != null ? args!['name'].toUpperCase() : ''}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900], 
                    ),
                  ),
                ),
                const SizedBox(height: 16), 
                // Container สำหรับโปรไฟล์สัตว์เลี้ยง
                Container(
                  width: 350,
                  decoration: containerDecoration, 
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      if (_imagePath != null && _imagePath!.isNotEmpty)
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage(_imagePath!),
                          backgroundColor: Colors.grey[300],
                        ),
                      const SizedBox(height: 16),

                      const Text(
                        'PROFILE',
                        style: profileTextStyle, 
                      ),
                      const SizedBox(height: 16),

                      // ชื่อสัตว์เลี้ยง
                      TextField(
                        controller: _nameController,
                        decoration: inputDecoration('Name'),
                      ),
                      const SizedBox(height: 16),

                      // ประเภทของสัตว์เลี้ยง
                      TextField(
                        controller: _petTypeController, 
                        decoration: inputDecoration('Type of Pet'), 
                      ),
                      const SizedBox(height: 16),

                      // วันเกิดของสัตว์เลี้ยง
                      TextField(
                        controller: _dateController,
                        decoration: inputDecoration('Date of Birth').copyWith(
                          suffixIcon: const Icon(Icons.calendar_today),
                      ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),

                      // น้ำหนักของสัตว์เลี้ยง
                      TextField(
                        controller: _weightController,
                        decoration: inputDecoration('Weight'), 
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // เพศของสัตว์เลี้ยง
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration('Sex'), 
                        value: _selectedSex,
                        items: ['Male', 'Female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSex = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // สายพันธุ์ของสัตว์เลี้ยง
                      TextField(
                        controller: _breedController,
                        decoration: inputDecoration('Breed'), 
                      ),
                      const SizedBox(height: 20),

                      // ปุ่ม Save
                      SizedBox(
                        width: double.infinity, 
                        child: ElevatedButton(
                          style: saveButtonStyle, 
                          onPressed: () => _submitForm(context),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

