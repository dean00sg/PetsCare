import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/signup_bloc.dart';
import 'package:frontend/bloc/signup_event.dart';
import 'package:frontend/bloc/signup_state.dart';
import 'package:frontend/models/signup_model.dart'; 
import 'package:frontend/styles/signup_style.dart'; 

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ตัวควบคุม TextEditingController เพื่อเก็บค่าจาก TextField
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 400,
                height: 800,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: containerDecoration,
                child: BlocListener<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupSuccess) {
                      Navigator.pushNamed(context, '/');
                    } else if (state is SignupFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 10),
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
                              "Already member? ",
                              style: generalTextStyle,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text(
                                "Sign in",
                                style: signInLinkStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'SIGN UP',
                          style: signUpTitleStyle,
                        ),
                        
                        const SizedBox(height: 30),
                        // First Name
                        TextField(
                          controller: firstNameController,
                          decoration: inputDecoration('FirstName'),
                        ),
                        const SizedBox(height: 25),
                        // Last Name
                        TextField(
                          controller: lastNameController,
                          decoration: inputDecoration('LastName'),
                        ),
                        const SizedBox(height: 25),
                        // Email
                        TextField(
                          controller: emailController,
                          decoration: inputDecoration('E-mail'),
                        ),
                        const SizedBox(height: 25),
                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: inputDecoration('Password'),
                        ),
                        const SizedBox(height: 25),
                        // Phone
                        TextField(
                          controller: phoneController,
                          decoration: inputDecoration('Phone'),
                        ),
                        const SizedBox(height: 30),
                        // Sign Up Button
                        ElevatedButton(
                          style: signUpButtonStyle,
                          onPressed: () {
                            final signupData = SignupModel(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                            );
                            BlocProvider.of<SignupBloc>(context).add(
                              SignupButtonPressed(signupData),
                            );
                          },
                          child: const Text('SIGN UP', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
