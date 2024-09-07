import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/signup_bloc.dart';
import 'package:frontend/users/bloc/signup_event.dart';
import 'package:frontend/users/bloc/signup_state.dart';
import 'package:frontend/users/models/signup_model.dart';
import 'package:frontend/users/styles/signup_style.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  // ตัวควบคุม TextEditingController เพื่อเก็บค่าจาก TextField
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: containerDecoration, // ใช้สีพื้นหลังตามสไตล์
              width: 320, // ปรับขนาดของ Container ให้เหมาะสมกับหน้าจอมือถือ
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // เพิ่มกรอบวงกลมให้กับรูปภาพ
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
                  const SizedBox(height: 16),
                  const Text('SIGN UP', style: signUpTitleStyle),
                  const SizedBox(height: 16),
                  // ฟอร์มสำหรับกรอกข้อมูลผู้ใช้
                  Form(
                    child: Column(
                      children: [
                        TextField(
                          controller: _firstNameController,
                          decoration: inputDecoration('FirstName'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _lastNameController,
                          decoration: inputDecoration('LastName'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: inputDecoration('E-mail'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: inputDecoration('Password'),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _phoneController,
                          decoration: inputDecoration('Phone'),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                        // ปุ่มสมัครสมาชิก
                        BlocConsumer<SignupBloc, SignupState>(
                          listener: (context, state) {
                            if (state is SignupSuccess) {
                              Navigator.pushNamed(context, '/profile', arguments: state.user);
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
                            return ElevatedButton(
                              style: signUpButtonStyle, // ใช้สไตล์ปุ่มจาก signup_style.dart
                              onPressed: () {
                                final signupData = SignupModel(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  phone: _phoneController.text,
                                );
                                context.read<SignupBloc>().add(SignupButtonPressed(signupData: signupData));
                              },
                              child: const Text('SIGN IN', style: TextStyle(fontSize: 18)),
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
      ),
    );
  }
}
