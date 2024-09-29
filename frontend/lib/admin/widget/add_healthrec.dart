import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/style/add_healthrec_style.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/state/profile_state.dart';
import 'package:frontend/admin/bloc/add_healthrec.dart';
import 'package:frontend/admin/event/add_healthrec.dart';
import 'package:frontend/admin/models/chechhealth_rec.dart';
import 'package:frontend/admin/state/add_healthrec.dart';

class AddHealthRecordForm extends StatefulWidget {
  const AddHealthRecordForm({super.key});

  @override
  _AddHealthRecordFormState createState() => _AddHealthRecordFormState();
}

//ตัวแปรสำหรับข้อมูลใช้กรอกฟอร์ม
class _AddHealthRecordFormState extends State<AddHealthRecordForm> {
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
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).loadProfile(); //โหลดข้อมูลโปรไฟล์แอดมิน
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Health Record", style: appBarTitleTextStyle),
        backgroundColor: primaryColor,
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AddHealthRecordBloc, AddHealthRecordState>(
        listener: (context, state) {
          if (state is HealthRecordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is HealthRecordSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Health record submitted successfully')),
            );
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Add Health Record",
                        style: headerTextStyle,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: formContainerDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Icon Profile Admin
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: profileContainerDecoration,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: state.profile.imageUrl !=
                                          null
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
                                      style: profileNameTextStyle,
                                    ),
                                    Text(state.profile.email,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                buildCustomField('Header:', _headerController),
                                const SizedBox(height: 10),
                                buildDropdownField(
                                    'Pets Type', _petTypeController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'Start Age (Years)', _ageYearsController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'Start Age (Months)', _ageMonthsController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'Start Age (Days)', _ageDaysController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'End Age (Years)', _toAgeYearsController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'End Age (Months)', _toAgeMonthsController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'End Age (Days)', _toAgeDaysController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'Start Weight', _weightStartController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'End Weight', _weightEndController),
                                const SizedBox(height: 10),
                                buildCustomField(
                                    'Description', _descriptionController,
                                    maxLines: 3),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final healthRecord = HealthRecord(
                                          HR_id: 0,
                                          header: _headerController.text,
                                          petType: _petTypeController.text,
                                          age: Age(
                                            years: int.parse(
                                                _ageYearsController.text),
                                            months: int.parse(
                                                _ageMonthsController
                                                        .text.isEmpty
                                                    ? '0'
                                                    : _ageMonthsController
                                                        .text),
                                            days: int.parse(
                                                _ageDaysController.text.isEmpty
                                                    ? '0'
                                                    : _ageDaysController.text),
                                          ),
                                          toAge: ToAge(
                                            years: int.parse(
                                                _toAgeYearsController
                                                        .text.isEmpty
                                                    ? '0'
                                                    : _toAgeYearsController
                                                        .text),
                                            months: int.parse(
                                                _toAgeMonthsController
                                                        .text.isEmpty
                                                    ? '0'
                                                    : _toAgeMonthsController
                                                        .text),
                                            days: int.parse(_toAgeDaysController
                                                    .text.isEmpty
                                                ? '0'
                                                : _toAgeDaysController.text),
                                          ),
                                          weightStartMonths: double.parse(
                                              _weightStartController.text),
                                          weightEndMonths: double.parse(
                                              _weightEndController.text),
                                          description:
                                              _descriptionController.text,
                                          recordDate: DateTime.now(),
                                        );

                                        context.read<AddHealthRecordBloc>().add(
                                              SubmitHealthRecord(healthRecord),
                                            );
                                      }
                                    },
                                    style: elevatedButtonStyle,
                                    child: const Text(
                                      "Save",
                                      style: buttonTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoadFailure) {
              return const Center(child: Text('Failed to load profile'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  //สร้างฟอร์มแบบข้อมูลแบบกำหนดเอง
  Widget buildCustomField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: formLabelTextStyle,
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: textFieldDecoration,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  //เลือกประเภทสัตว์
  Widget buildDropdownField(String label, TextEditingController controller) {
    List<String> petTypes = ['Dog', 'Cat', 'Rabbit', 'Fish'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: formLabelTextStyle,
        ),
        DropdownButtonFormField<String>(
          decoration: textFieldDecoration,
          items: petTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            controller.text = value ?? '';
          },
        ),
      ],
    );
  }
}
