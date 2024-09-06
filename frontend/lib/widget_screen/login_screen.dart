import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/login_bloc.dart';
import 'package:frontend/bloc/login_event.dart';
import 'package:frontend/bloc/login_state.dart';
import 'package:frontend/models/login_model.dart'; 
import 'package:frontend/styles/login_style.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ตัวควบคุม TextEditingController เพื่อเก็บค่าจาก TextField
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/images/logo.png',
                height: 300, // ขนาดความสูง logo
                width: 300, // ขนาดความกว้าง logo
                fit: BoxFit.contain,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                width: 350,
                height: 400,
                decoration: containerDecoration, // ใช้สไตล์ Container จาก login_style
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'SIGN IN',
                        style: signInTitleStyle, // ใช้สไตล์ Title จาก login_style
                      ),
                      const SizedBox(height: 16),
                      // Username Field
                      TextField(
                        controller: usernameController,
                        decoration: inputDecoration('User/Email'), // ใช้สไตล์ TextField จาก login_style
                      ),
                      const SizedBox(height: 30),
                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: inputDecoration('Password'), // ใช้สไตล์ TextField จาก login_style
                      ),
                      const SizedBox(height: 24),
                      // Sign In Button
                      ElevatedButton(
                        style: loginButtonStyle, // ใช้สไตล์ปุ่มจาก login_style
                        onPressed: () {
                          final loginData = LoginModel(
                            username: usernameController.text,
                            password: passwordController.text,
                          );
                          BlocProvider.of<LoginBloc>(context).add(
                            LoginButtonPressed(loginData),
                          );
                        },
                        child: const Text('SIGN IN', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 16),
                      // Sign Up Button
                      ElevatedButton(
                        style: loginButtonStyle, // ใช้สไตล์ปุ่มจาก login_style
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup'); // นำไปยังหน้าสมัครใช้งาน
                        },
                        child: const Text('SIGN UP', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    Navigator.pushNamed(context, '/feed');
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Container(); // แสดงคอนเทนต์ตามปกติเมื่อไม่มีการโหลด
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
