import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/signup_bloc.dart';
import 'package:frontend/users/event/signup_event.dart';
import 'package:frontend/users/state/signup_state.dart';
import 'package:frontend/users/models/signup_model.dart';
import 'package:frontend/users/styles/signup_style.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: containerDecoration,
            width: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'lib/images/logo.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already a member? ",
                      style: generalTextStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Sign in",
                        style: signInLinkStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('SIGN UP', style: signUpTitleStyle),
                const SizedBox(height: 16),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        decoration: inputDecoration('First Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: inputDecoration('Last Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: inputDecoration('E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: inputDecoration('Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contactNumberController,
                        decoration: inputDecoration('Contact Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact number is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocConsumer<SignupBloc, SignupState>(
                        listener: (context, state) {
                          if (state is SignupSuccess) {
                            // เมื่อ signup สำเร็จ นำทางไปยังหน้า login
                            Navigator.pushReplacementNamed(context, '/login');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Signup Successful! Please log in.'),
                              ),
                            );
                          } else if (state is SignupFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is SignupLoading) {
                            return const CircularProgressIndicator();
                          }
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: signUpButtonStyle,
                              onPressed: () {
                                if (Form.of(context).validate()) {
                                  final signupData = SignupModel(
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    contactNumber: _contactNumberController.text,
                                  );
                                  context.read<SignupBloc>().add(SignupButtonPressed(signupData: signupData));
                                }
                              },
                              child: const Text('SIGN UP', style: TextStyle(fontSize: 18)),
                            ),
                          );
                        },
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
