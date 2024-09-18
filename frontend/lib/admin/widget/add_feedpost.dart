import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_feedpost.dart';
import 'package:frontend/admin/event/add_feedpost.dart';
import 'package:frontend/admin/models/add_feedpost.dart';
import 'package:frontend/admin/state/add_feedpost.dart';
import 'package:frontend/admin/style/add_feedpost_style.dart';
import 'package:intl/intl.dart';

import '../appbar/navbar.dart';
import '../appbar/slidebar.dart';

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

  Future<void> _selectDateTime(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(), 
      drawer: const Sidebar(), 
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   title: const Text('Feed Post', style: TextStyle(fontSize: 22, color: Colors.white)),
      //   backgroundColor: const Color.fromARGB(255, 38, 111, 202), 
      //   centerTitle: true,
      //   toolbarHeight: 70,
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Feed Post',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  //width: 320,
                  decoration: mainContainerDecoration, 
                  padding: const EdgeInsets.all(16.0),
                  child: BlocListener<AddFeedBloc, FeedState>(
                    listener: (context, state) {
                      if (state is FeedSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Feed post added successfully')),
                        );
                        Navigator.pushNamed(context, '/feedadmin'); // Navigate to '/feed' after success
                      } else if (state is FeedFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add post: ${state.error}')),
                        );
                      }
                    },
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Header :', 
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: _headerController,
                            decoration: inputDecoration('Header'),
                            validator: (value) => value!.isEmpty ? 'Please enter a header' : null,
                          ),
                          const SizedBox(height: 10),
                          
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Start DateTime :', 
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: _startDateController,
                            decoration: inputDecoration('Start DateTime').copyWith(
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            readOnly: true, // Makes the field read-only
                            onTap: () => _selectDateTime(context, _startDateController),
                            validator: (value) => value!.isEmpty ? 'Please select a start date and time' : null,
                          ),
                          const SizedBox(height: 10),
                          
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'End DateTime :', 
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: _endDateController,
                            decoration: inputDecoration('End DateTime').copyWith(
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () => _selectDateTime(context, _endDateController),
                            validator: (value) => value!.isEmpty ? 'Please select an end date and time' : null,
                          ),
                          const SizedBox(height: 10),
                          
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Image URL :', 
                              style: TextStyle(color: Colors.white, fontSize: 16),
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
                              style: TextStyle(color: Colors.white, fontSize: 16),
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
                              style: submitButtonStyle, // ใช้สไตล์ที่สร้างไว้
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final post = FeedPost(
                                    header: _headerController.text,
                                    startDatetime: DateTime.parse(_startDateController.text),
                                    endDatetime: DateTime.parse(_endDateController.text),
                                    imageUrl: _imageUrlController.text,
                                    description: _descriptionController.text,
                                  );
                                  BlocProvider.of<AddFeedBloc>(context).add(AddFeedPostEvent(post));
                                }
                              },
                              child: const Text('Save', style: TextStyle(color: Colors.white), ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
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