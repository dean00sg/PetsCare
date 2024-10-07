import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_feedpost.dart';
import 'package:frontend/admin/event/add_feedpost.dart';
import 'package:frontend/admin/models/add_feedpost.dart';
import 'package:frontend/admin/state/add_feedpost.dart';
import 'package:frontend/admin/style/add_feedpost_style.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/state/profile_state.dart';
import 'package:intl/intl.dart';

class FeedPostWidget extends StatefulWidget {
  const FeedPostWidget({super.key});

  @override
  _FeedPostWidgetState createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Feed Post',
            style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 111, 202),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Feed',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: mainContainerDecoration,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      //profile admin
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            return const CircularProgressIndicator();
                          } else if (state is ProfileLoaded) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(
                                      12.0), 
                                  margin: const EdgeInsets.only(
                                      bottom:
                                          15), 
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            state.profile.imageUrl != null
                                                ? NetworkImage(
                                                    state.profile.imageUrl!)
                                                : null,
                                        radius: 30,
                                        child: state.profile.imageUrl == null
                                            ? const Icon(Icons.person, size: 30)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${state.profile.firstName} ${state.profile.lastName}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            state.profile.email,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      const SizedBox(height: 16),
                      BlocListener<AddFeedBloc, FeedState>(
                        listener: (context, state) {
                          if (state is FeedSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Feed post added successfully')),
                            );
                            Navigator.pushNamed(context,
                                '/feedadmin');
                          } else if (state is FeedFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to add post: ${state.error}')),
                            );
                          }
                        },
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Header :',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              TextFormField(
                                controller: _headerController,
                                decoration: inputDecoration('Header'),
                                validator: (value) => value!.isEmpty
                                    ? 'Please enter a header'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Start DateTime :',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              TextFormField(
                                controller: _startDateController,
                                decoration:
                                    inputDecoration('Start DateTime').copyWith(
                                  suffixIcon: const Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                onTap: () => _selectDateTime(
                                    context, _startDateController),
                                validator: (value) => value!.isEmpty
                                    ? 'Please select a start date and time'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'End DateTime :',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              TextFormField(
                                controller: _endDateController,
                                decoration:
                                    inputDecoration('End DateTime').copyWith(
                                  suffixIcon: const Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                onTap: () => _selectDateTime(
                                    context, _endDateController),
                                validator: (value) => value!.isEmpty
                                    ? 'Please select an end date and time'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Image URL :',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              TextFormField(
                                controller: _imageUrlController,
                                decoration: inputDecoration('Image URL'),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Description :',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: inputDecoration('Description'),
                                maxLines: 4,
                                minLines: 4,
                                keyboardType: TextInputType.multiline,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: submitButtonStyle,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final post = FeedPost(
                                        header: _headerController.text,
                                        startDatetime: DateTime.parse(
                                            _startDateController.text),
                                        endDatetime: DateTime.parse(
                                            _endDateController.text),
                                        imageUrl: _imageUrlController.text,
                                        description:
                                            _descriptionController.text,
                                      );
                                      BlocProvider.of<AddFeedBloc>(context)
                                          .add(AddFeedPostEvent(post));
                                    }
                                  },
                                  child: const Text('Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ),
                              ),
                              const SizedBox(height: 25),
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
      ),
    );
  }
}
