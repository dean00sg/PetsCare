import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_healthrec.dart';
import 'package:frontend/admin/event/add_healthrec.dart';
import 'package:frontend/admin/models/chechhealth_rec.dart';
import 'package:frontend/admin/state/add_healthrec.dart';

class AddHealthRecordForm extends StatefulWidget {
  const AddHealthRecordForm({super.key});

  @override
  _HealthRecordFormState createState() => _HealthRecordFormState();
}

class _HealthRecordFormState extends State<AddHealthRecordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _petTypeController = TextEditingController();
  final TextEditingController _ageYearsController = TextEditingController();
  final TextEditingController _ageMonthsController = TextEditingController();
  final TextEditingController _ageDaysController = TextEditingController();
  final TextEditingController _toAgeYearsController = TextEditingController();
  final TextEditingController _toAgeMonthsController = TextEditingController();
  final TextEditingController _toAgeDaysController = TextEditingController();
  final TextEditingController _weightStartController = TextEditingController();
  final TextEditingController _weightEndController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Health Record')),
      body: BlocListener<AddHealthRecordBloc, AddHealthRecordState>(
        listener: (context, state) {
          if (state is HealthRecordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is HealthRecordSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Health record submitted successfully')),
            );
            Navigator.of(context).pop(); // Navigate back after successful submission
          }
        },
        child: BlocBuilder<AddHealthRecordBloc, AddHealthRecordState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _headerController,
                      decoration: const InputDecoration(labelText: 'Header'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a header';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _petTypeController,
                      decoration: const InputDecoration(labelText: 'Pet Type'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pet type';
                        }
                        return null;
                      },
                    ),
                    // Age Input
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ageYearsController,
                            decoration: const InputDecoration(labelText: 'Age (Years)'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter age in years';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _ageMonthsController,
                            decoration: const InputDecoration(labelText: 'Age (Months)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _ageDaysController,
                            decoration: const InputDecoration(labelText: 'Age (Days)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    // To Age Input
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _toAgeYearsController,
                            decoration: const InputDecoration(labelText: 'To Age (Years)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _toAgeMonthsController,
                            decoration: const InputDecoration(labelText: 'To Age (Months)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _toAgeDaysController,
                            decoration: const InputDecoration(labelText: 'To Age (Days)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    // Weight Input
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightStartController,
                            decoration: const InputDecoration(labelText: 'Weight Start (Months)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _weightEndController,
                            decoration: const InputDecoration(labelText: 'Weight End (Months)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final healthRecord = HealthRecord(
                            HR_id: 0,
                            header: _headerController.text,
                            petType: _petTypeController.text,
                            age: Age(
                              years: int.parse(_ageYearsController.text),
                              months: int.parse(_ageMonthsController.text.isEmpty ? '0' : _ageMonthsController.text),
                              days: int.parse(_ageDaysController.text.isEmpty ? '0' : _ageDaysController.text),
                            ),
                            toAge: ToAge(
                              years: int.parse(_toAgeYearsController.text.isEmpty ? '0' : _toAgeYearsController.text),
                              months: int.parse(_toAgeMonthsController.text.isEmpty ? '0' : _toAgeMonthsController.text),
                              days: int.parse(_toAgeDaysController.text.isEmpty ? '0' : _toAgeDaysController.text),
                            ),
                            weightStartMonths: double.parse(_weightStartController.text),
                            weightEndMonths: double.parse(_weightEndController.text),
                            description: _descriptionController.text,
                            recordDate: DateTime.now(),
                          );

                          context.read<AddHealthRecordBloc>().add(
                            SubmitHealthRecord(healthRecord),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
