import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_vaccination.dart';
import 'package:frontend/admin/event/add_vaccination.dart';
import 'package:frontend/admin/models/vaccination.dart';
import 'package:frontend/admin/repositories/petprofileuser.dart';
import 'package:frontend/admin/state/add_vaccination.dart';
import 'package:frontend/admin/models/petprofileuser.dart';
import 'package:frontend/admin/style/add_vaccination_style.dart'; 
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/state/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddVaccinationScreen extends StatefulWidget {
  const AddVaccinationScreen({super.key});

  @override
  _AddVaccinationScreenState createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  DateTime? selectedDate;
  final locationController = TextEditingController();
  final remarkController = TextEditingController();
  final vacNameController = TextEditingController();
  final doseController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

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
    _loadUsername();
  }

  Future<void> _loadPetProfiles() async {
    PetProfileUserRepository repository = PetProfileUserRepository();
    List<PetProfileUserModel> profiles = await repository.fetchPets();

    setState(() {
      petProfiles = profiles;
      ownerNames = profiles.map((pet) => pet.owner_name).toSet().toList(); 
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
      selectedPet = null; 
     
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddVaccinationBloc, AddVaccinationState>(
      listener: (context, state) {
        if (state is AddVaccinationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarStyle); // ใช้สไตล์ SnackBar ที่แยกไว้
          Navigator.pop(context); // Navigate back after success
        } else if (state is AddVaccinationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Pet Vaccination",
              style: TextStyle(fontSize: 22, color: Colors.white)),
          backgroundColor: const Color(0xFF266FCA),
          centerTitle: true,
          toolbarHeight: 70,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: 4),
              Text(
                'Add Vaccination',
                style: titleTextStyle, 
              ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: containerBoxDecoration,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: profileContainerBoxDecoration, 
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: state.profile.imageUrl != null
                                            ? NetworkImage(state.profile.imageUrl!)
                                            : null,
                                        radius: 30,
                                        child: state.profile.imageUrl == null
                                            ? const Icon(Icons.person, size: 30)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${state.profile.firstName} ${state.profile.lastName}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(state.profile.email,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('Owner :', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TypeAheadFormField<String>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          controller: _typeAheadController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            suffixIcon: const Icon(Icons.search, color: Colors.blue,),
                                          ),
                                        ),
                                        suggestionsCallback: (pattern) {
                                          return ownerNames.where((owner) => owner
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                        },
                                        itemBuilder: (context, String suggestion) {
                                          return ListTile(
                                            title: Text(suggestion),
                                          );
                                        },
                                        onSuggestionSelected: (String suggestion) {
                                          setState(() {
                                            selectedOwner = suggestion;
                                            _typeAheadController.text = suggestion;
                                          });
                                          _onOwnerChanged(suggestion);
                                        },
                                        noItemsFoundBuilder: (context) => const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('No owners found'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text('Pet Name:', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: DropdownButton<String>(
                                    value: selectedPet,
                                    hint: const Text(''),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedPet = newValue;
                                      });
                                    },
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    items: petNames.map<DropdownMenuItem<String>>((String pet) {
                                      return DropdownMenuItem<String>(
                                        value: pet,
                                        child: Text(pet),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('Vaccination Name :', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: vacNameController,
                                  decoration: inputDecorationStyle,
                                ),
                                const SizedBox(height: 10),
                                const Text('Dose :', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: doseController,
                                  decoration: inputDecorationStyle,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 10),
                                const Text('Dose Datetime :', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: selectedDate != null
                                            ? "${selectedDate!.toLocal()}".split(' ')[0]
                                            : ' ',
                                        suffixIcon: const Icon(Icons.calendar_today),
                                        filled: true,
                                        fillColor: Colors.white, 
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('Location :', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: locationController,
                                  decoration: inputDecorationStyle,
                                ),
                                const SizedBox(height: 10),
                                const Text('Remark : Optional', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: remarkController,
                                  decoration: inputDecorationStyle,
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: submitButtonStyle,
                                    onPressed: () {
                                      if (selectedOwner != null &&
                                          selectedPet != null &&
                                          selectedDate != null &&
                                          username != null) {
                                            final selectedPetProfile = petProfiles
                                          .firstWhere((pet) => pet.name == selectedPet);
                                        final profile = AddPetVacProfile(
                                          petsId: selectedPetProfile.petsId,
                                          dose: int.parse(doseController.text),
                                          vacName: vacNameController.text,
                                          startDateVac: selectedDate!,
                                          location: locationController.text,
                                          remark: remarkController.text,
                                          petName: selectedPet!,
                                          ownerName: selectedOwner!,
                                          noteBy: username!,
                                        );

                                        // Dispatch the event to the bloc
                                        context
                                            .read<AddVaccinationBloc>()
                                            .add(SubmitVaccinationForm(profile));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('Please fill out all fields')),
                                        );
                                      }
                                    },
                                    child: const Text('Save',
                                      style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
