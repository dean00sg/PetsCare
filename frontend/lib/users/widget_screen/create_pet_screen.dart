import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/create_pet_bloc.dart';
import 'package:frontend/users/event/create_pet_event.dart';
import 'package:frontend/users/models/create_pet_model.dart';
import 'package:frontend/users/state/create_pet_state.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _petTypeController.text = args['name'];  // Set type of pet
      _imagePath = args['imagePath'];
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              if (_imagePath != null && _imagePath!.isNotEmpty)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(_imagePath!),
                  backgroundColor: Colors.grey[300],
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _petTypeController, 
                decoration: const InputDecoration(labelText: 'Type of Pet'),
              ),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sex'),
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
              TextField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Breed'),
              ),
              
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
