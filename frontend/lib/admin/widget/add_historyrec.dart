import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/add_historyrec.dart';
import 'package:frontend/admin/models/historyrec.dart';
import 'package:frontend/admin/bloc/add_historyrec.dart';
import 'package:frontend/admin/models/petprofileuser.dart';
import 'package:frontend/admin/repositories/historyrec.dart';
import 'package:frontend/admin/repositories/petprofileuser.dart';
import 'package:frontend/admin/state/add_historyrec.dart';
import 'package:frontend/users/models/profile_model.dart';
import 'package:frontend/users/repositories/profile_repository.dart';
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

  String? username;
  String? noteName;
  late ProfileRepository profileRepository;
  late PetProfileUserRepository petProfileUserRepository;
  List<PetProfileUserModel> pets = [];
  List<String> ownerNames = [];
  String? selectedPet;
  String? selectedOwner;
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _loadUsername();
    profileRepository = ProfileRepository(apiUrl: 'http://10.0.2.2:8000');
    petProfileUserRepository = PetProfileUserRepository();
    _fetchUserProfile();
    _fetchPets();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      UserProfile profile = await profileRepository.getProfile();
      setState(() {
        noteName = '${profile.firstName} ${profile.lastName}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _fetchPets() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      pets = await petProfileUserRepository.fetchPets();
      ownerNames = pets.map((pet) => pet.owner_name).toSet().toList();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void _onOwnerChanged(String? newValue) {
    setState(() {
      selectedOwner = newValue;
      selectedPet = null;
    });
  }

  void _onPetChanged(String? newValue) {
    setState(() {
      selectedPet = newValue;
    });
  }

  void _submitForm() {
    if (headerController.text.isEmpty ||
        symptomsController.text.isEmpty ||
        diagnoseController.text.isEmpty ||
        remarkController.text.isEmpty ||
        selectedPet == null ||
        selectedOwner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final newRecord = AddHistoryRec(
      header: headerController.text,
      symptoms: symptomsController.text,
      diagnose: diagnoseController.text,
      remark: remarkController.text,
      petName: selectedPet!,
      ownerName: selectedOwner!,
    );

    context.read<AddHistoryRecBloc>().add(SubmitHistoryRecForm(newRecord));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHistoryRecBloc(repository: HistoryRepository(apiUrl: 'http://10.0.2.2:8000')),
      child: BlocListener<AddHistoryRecBloc, AddHistoryRecState>(
        listener: (context, state) {
          if (state is AddHistoryRecSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('History record added successfully')),
            );

            // Clear the text fields after success
            headerController.clear();
            symptomsController.clear();
            diagnoseController.clear();
            remarkController.clear();
            selectedPet = null;
            selectedOwner = null;

            Navigator.pop(context); // Navigate back on success
          } else if (state is AddHistoryRecFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add history record: ${state.error}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add History Record'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading // Show loading indicator
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: headerController,
                        decoration: const InputDecoration(labelText: 'Header'),
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
                      DropdownButton<String>(
                        value: selectedOwner,
                        onChanged: _onOwnerChanged,
                        items: ownerNames.map((owner) {
                          return DropdownMenuItem<String>(
                            value: owner,
                            child: Text(owner),
                          );
                        }).toList(),
                        hint: const Text('Select Owner'),
                      ),
                      DropdownButton<String>(
                        value: selectedPet,
                        onChanged: _onPetChanged,
                        items: pets
                            .where((pet) => pet.owner_name == selectedOwner)
                            .map((pet) {
                          return DropdownMenuItem<String>(
                            value: pet.name,
                            child: Text(pet.name),
                          );
                        }).toList(),
                        hint: const Text('Select Pet'),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
