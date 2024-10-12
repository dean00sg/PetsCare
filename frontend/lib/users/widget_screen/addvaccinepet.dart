import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/add_vaccination.dart';
import 'package:frontend/users/event/add_vaccination.dart';
import 'package:frontend/users/models/petprofile.dart';
import 'package:frontend/users/models/vaccination_pet.dart';
import 'package:frontend/users/repositories/petprofile.dart';
import 'package:frontend/users/state/add_vaccination.dart';
import 'package:frontend/users/styles/add_vaccination_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddvaccinePetsScreen extends StatefulWidget {
  const AddvaccinePetsScreen({super.key});

  @override
  _AddvaccinePetsScreen createState() => _AddvaccinePetsScreen();
}

class _AddvaccinePetsScreen extends State<AddvaccinePetsScreen> {
  DateTime? selectedDate;
  final locationController = TextEditingController();
  final remarkController = TextEditingController();
  final vacNameController = TextEditingController();
  final doseController = TextEditingController();
  final dateController = TextEditingController();

  PetProfile? petProfile;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();

    // รับ arguments จากหน้าที่เรียกมา
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        final petsId = arguments['petsId'];
        await _loadPetProfile(petsId);
      }
    });
  }

  Future<void> _loadPetProfile(int petsId) async {
    PetProfileRepository repository = PetProfileRepository();
    try {
      PetProfile profile = await repository.fetchPetByName(petsId.toString());
      setState(() {
        petProfile = profile;
      });
    } catch (e) {
      print('Error loading pet profile: $e');
    }
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
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
        dateController.text = "${selectedDate!.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VaccinationBloc, VaccinationState>(
      listener: (context, state) {
        if (state is VaccinationAdded) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarStyle);
          Navigator.pop(context);
        } else if (state is VaccinationError) {
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
          backgroundColor: Colors.brown,
          centerTitle: true,
          toolbarHeight: 70,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Vaccination',
                  style: titleTextStyle,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: containerBoxDecoration,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Vaccination Name :',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: vacNameController,
                        decoration: inputDecorationStyle,
                      ),
                      const SizedBox(height: 10),
                      const Text('Dose :',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: doseController,
                        decoration: inputDecorationStyle,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      const Text('Dose Datetime :',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: dateController,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Location :',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: locationController,
                        decoration: inputDecorationStyle,
                      ),
                      const SizedBox(height: 10),
                      const Text('Remark : Optional',
                          style: TextStyle(color: Colors.black)),
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
                            if (petProfile != null &&
                                selectedDate != null &&
                                username != null) {
                              final profile = AddPetVacProfile(
                                petsId: petProfile!.petsId,
                                dose: int.parse(doseController.text),
                                vacName: vacNameController.text,
                                startDateVac: selectedDate!,
                                location: locationController.text,
                                remark: remarkController.text,
                                petName: petProfile!.name,
                                ownerName: petProfile!.ownerName,
                                noteBy: username!,
                              );

                              context
                                  .read<VaccinationBloc>()
                                  .add(AddVaccinationEvent(profile));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please fill out all fields')),
                              );
                            }
                          },
                          child: const Text('Save',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 30),
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
