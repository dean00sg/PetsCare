import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/login_bloc.dart';
import 'package:frontend/bloc/login_event.dart';
import 'package:frontend/bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        backgroundColor: Colors.white, // กำหนดสีพื้นหลัง Scaffold
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
                margin: const EdgeInsets.symmetric(horizontal: 20.0), // กำหนด margin ด้านซ้ายและขวา
                padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0), // กำหนด padding ของ Container ด้านซ้าย, บน, ขวา, ล่าง
                width: 350, // กำหนดความกว้าง container
                height: 400, // กำหนดความสูง container
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 83, 65), // กำหนดสีพื้นหลังของ Container
                  borderRadius: BorderRadius.circular(25), // กำหนดมุมโค้งของ Container
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255), // กำหนดสีพื้นหลัง TextField
                          hintText: 'User/Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)), // กำหนดมุมโค้งของ TextField
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255), // กำหนดสีพื้นหลัง TextField
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, // สีปุ่ม
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50), // กำหนดขนาดของปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24), // มุมโค้งของปุ่ม
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            const LoginButtonPressed(
                              username: 'user',
                              password: 'password',
                            ),
                          );
                        },
                        child: const Text('SIGN IN', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, // สีปุ่ม Sign Up
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
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
                    // เมื่อเข้าสู่ระบบสำเร็จ นำผู้ใช้ไปที่หน้าฟีด
                    Navigator.pushNamed(context, '/feed');
                  } else if (state is LoginFailure) {
                    // ถ้าเข้าสู่ระบบล้มเหลว แสดงข้อความแจ้งเตือน
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
