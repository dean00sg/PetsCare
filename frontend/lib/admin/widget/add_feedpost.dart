import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_feedpost.dart';
import 'package:frontend/admin/event/add_feedpost.dart';
import 'package:frontend/admin/models/add_feedpost.dart';
import 'package:frontend/admin/state/add_feedpost.dart';
import 'package:intl/intl.dart'; // For formatting the date and time

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
      lastDate: DateTime(2101),
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

        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime); // Formatting the selected date and time
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add FeedPost'),
      ),
      body: Padding(
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
              children: [
                TextFormField(
                  controller: _headerController,
                  decoration: const InputDecoration(labelText: 'Header'),
                  validator: (value) => value!.isEmpty ? 'Please enter a header' : null,
                ),
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Start DateTime',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Makes the field read-only
                  onTap: () => _selectDateTime(context, _startDateController),
                  validator: (value) => value!.isEmpty ? 'Please select a start date and time' : null,
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(
                    labelText: 'End DateTime',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDateTime(context, _endDateController),
                  validator: (value) => value!.isEmpty ? 'Please select an end date and time' : null,
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
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
