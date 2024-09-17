import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/style/profile.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/models/profile_model.dart';


class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _phone;

  @override
  void initState() {
    super.initState();
    _firstName = widget.profile.firstName;
    _lastName = widget.profile.lastName;
    _email = widget.profile.email;
    _phone = widget.profile.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Profile', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 111, 202), 
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20.0),
          decoration: profileContainerDecoration,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('PROFILE ADMIN', style: titleStyle),
                const SizedBox(height: 20),

                // First Name
                Container(
                  padding: containerPadding,
                  decoration: containerDecoration,
                  child: TextFormField(
                    initialValue: _firstName,
                    decoration: const InputDecoration(labelText: 'First Name', border: InputBorder.none),
                    onSaved: (value) {
                      _firstName = value!;
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Last Name
                Container(
                  padding: containerPadding,
                  decoration: containerDecoration,
                  child: TextFormField(
                    initialValue: _lastName,
                    decoration: const InputDecoration(labelText: 'Last Name', border: InputBorder.none),
                    onSaved: (value) {
                      _lastName = value!;
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Email (Non-editable)
                Container(
                  padding: containerPadding,
                  decoration: containerDecoration,
                  child: TextFormField(
                    initialValue: _email,
                    decoration: const InputDecoration(labelText: 'Email', border: InputBorder.none),
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 12),

                // Phone
                Container(
                  padding: containerPadding,
                  decoration: containerDecoration,
                  child: TextFormField(
                    initialValue: _phone,
                    decoration: const InputDecoration(labelText: 'Phone', border: InputBorder.none),
                    onSaved: (value) {
                      _phone = value!;
                    },
                  ),
                ),
                const SizedBox(height: 25),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: editButtonStyle,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final updatedProfile = UserProfile(
                          firstName: _firstName,
                          lastName: _lastName,
                          email: _email,
                          phone: _phone,
                        );
                        context.read<ProfileBloc>().updateProfile(updatedProfile);
                        Navigator.pop(context, true); // Indicate profile updated
                      }
                    },
                    child: const Text('Save', style: TextStyle(fontSize: 16)),
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
