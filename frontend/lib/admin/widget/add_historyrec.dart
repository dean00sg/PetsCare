import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_historyrec.dart'; // History record bloc
import 'package:frontend/admin/event/add_historyrec.dart'; // History record event
import 'package:frontend/admin/models/historyrec.dart'; // History record model
import 'package:frontend/admin/models/petprofileuser.dart';
import 'package:frontend/admin/repositories/petprofileuser.dart';
import 'package:frontend/admin/state/add_historyrec.dart'; // History record state
import 'package:shared_preferences/shared_preferences.dart';

class AddHistoryRecScreen extends StatefulWidget {
  const AddHistoryRecScreen({super.key});

  @override
  _AddHistoryRecScreenState createState() => _AddHistoryRecScreenState();
}

class _AddHistoryRecScreenState extends State<AddHistoryRecScreen> {
  final headerController = TextEditingController();
  final symptomsController = TextEditingController();
  final diagnoseController = TextEditingController();
  final remarkController = TextEditingController();
  
  // Pet and Owner dropdown states
  List<PetProfileUserModel> petProfiles = [];
  List<String> ownerNames = [];
  List<String> petNames = [];

  String? selectedOwner;
  String? selectedPet;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadPetProfiles();
    _loadUsername(); // Load username when initializing the screen
  }

  Future<void> _loadPetProfiles() async {
    PetProfileUserRepository repository = PetProfileUserRepository();
    List<PetProfileUserModel> profiles = await repository.fetchPets();

    setState(() {
      petProfiles = profiles;
      ownerNames = profiles.map((pet) => pet.owner_name).toSet().toList(); // Get unique owner names
    });
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  void _onOwnerChanged(String? newValue) {
    setState(() {
      selectedOwner = newValue;
      petNames = petProfiles
          .where((pet) => pet.owner_name == selectedOwner)
          .map((pet) => pet.name)
          .toList();
      selectedPet = null; // Reset selected pet when owner changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddHistoryRecBloc, AddHistoryRecState>(
      listener: (context, state) {
        if (state is AddHistoryRecSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('History record added successfully')),
          );
          Navigator.pop(context); // Navigate back after success
        } else if (state is AddHistoryRecFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add History Record'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Owner Name Dropdown
              DropdownButton<String>(
                value: selectedOwner,
                hint: const Text('Select Owner'),
                onChanged: _onOwnerChanged,
                items: ownerNames.map<DropdownMenuItem<String>>((String owner) {
                  return DropdownMenuItem<String>(
                    value: owner,
                    child: Text(owner),
                  );
                }).toList(),
              ),
              
              // Pet Name Dropdown
              DropdownButton<String>(
                value: selectedPet,
                hint: const Text('Select Pet'),
                onChanged: (newValue) {
                  setState(() {
                    selectedPet = newValue;
                  });
                },
                items: petNames.map<DropdownMenuItem<String>>((String pet) {
                  return DropdownMenuItem<String>(
                    value: pet,
                    child: Text(pet),
                  );
                }).toList(),
              ),
              
              TextField(
                controller: headerController,
                decoration: const InputDecoration(labelText: 'Record Header'),
              ),
              TextField(
                controller: symptomsController,
                decoration: const InputDecoration(labelText: 'Symptoms'),
              ),
              TextField(
                controller: diagnoseController,
                decoration: const InputDecoration(labelText: 'Diagnose'),
              ),
              TextField(
                controller: remarkController,
                decoration: const InputDecoration(labelText: 'Remark'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedOwner != null && selectedPet != null && username != null) {
                    final record = AddHistoryRec(
                      header: headerController.text,
                      symptoms: symptomsController.text,
                      diagnose: diagnoseController.text,
                      remark: remarkController.text,
                      petName: selectedPet!,
                      ownerName: selectedOwner!,
                    );

                    // Dispatch the event to the bloc
                    context.read<AddHistoryRecBloc>().add(SubmitHistoryRecForm(record));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill out all fields')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
