import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_notification.dart';
import 'package:frontend/admin/event/add_notification.dart';
import 'package:frontend/admin/state/add_notification.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/state/profile_state.dart';


class AddNotificationScreen extends StatefulWidget {
  const AddNotificationScreen({super.key});

  @override
  _AddNotificationScreenState createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // Controller for image URL
  DateTime? _startDate;
  DateTime? _endDate;
  String? _toUser;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddNotificationBloc>(context).add(LoadUsersForNotification());
    BlocProvider.of<ProfileBloc>(context).loadProfile();  // Load the profile when screen starts
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocListener<AddNotificationBloc, AddNotificationState>(
        listener: (context, state) {
          if (state is AddNotificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification Saved')));
          } else if (state is AddNotificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile section
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(_imageUrlController.text.isNotEmpty
                                    ? _imageUrlController.text
                                    : 'https://via.placeholder.com/150'), // Replace with actual image URL
                                radius: 30,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${state.profile.firstName} ${state.profile.lastName}",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(state.profile.email, style: const TextStyle(color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProfileLoadFailure) {
                    return const Text('Failed to load profile');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),

              // Notification form
              const Text("Add Notifications", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              BlocBuilder<AddNotificationBloc, AddNotificationState>(
                builder: (context, state) {
                  if (state is UsersLoadedForNotification) {
                    final userPetsList = state.users.where((user) => user.role == 'userpets').toList();
                    return DropdownButtonFormField<String>(
                      value: _toUser,
                      onChanged: (value) => setState(() => _toUser = value),
                      items: userPetsList.map((user) {
                        return DropdownMenuItem(value: user.email, child: Text(user.email));
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: "To user",
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    );
                  } else if (state is AddNotificationLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text("Failed to load users");
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _headerController,
                decoration: const InputDecoration(
                  labelText: "Header",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _imageUrlController, // Image URL input
                decoration: const InputDecoration(
                  labelText: "Images URL",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, isStartDate: true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: _startDate == null
                                ? 'startdatetime'
                                : 'Start Date: ${_startDate!.toLocal()}'.split(' ')[0],
                            suffixIcon: const Icon(Icons.calendar_today),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, isStartDate: false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: _endDate == null
                                ? 'enddatetime'
                                : 'End Date: ${_endDate!.toLocal()}'.split(' ')[0],
                            suffixIcon: const Icon(Icons.calendar_today),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _detailController,
                decoration: const InputDecoration(
                  labelText: "Detail",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_toUser != null &&
                        _headerController.text.isNotEmpty &&
                        _startDate != null &&
                        _endDate != null &&
                        _imageUrlController.text.isNotEmpty) {
                      context.read<AddNotificationBloc>().add(AddNotificationSubmitted(
                        header: _headerController.text,
                        toUser: _toUser!,
                        startNoti: _startDate!,
                        endNoti: _endDate!,
                        file: _imageUrlController.text,
                        detail: _detailController.text,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill out all fields')),
                      );
                    }
                  },
                  child: const Text("Submit", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
