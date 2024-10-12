import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/login_bloc.dart';
import 'package:frontend/users/event/login_event.dart';
import 'package:frontend/users/models/login_model.dart';
import 'package:frontend/users/state/login_state.dart';
import 'package:frontend/users/styles/login_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            print("Login successful with role: ${state.role}");
            if (state.role == 'admin') {
              Navigator.pushNamed(context, '/feedadmin'); 
            } else if (state.role == 'userpets') {
              Navigator.pushNamed(context, '/feed'); 
            }
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: SingleChildScrollView( 
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60),
                Image.asset(
                  'lib/images/logo.png',
                  height: 300,
                  width: 300,
                  fit: BoxFit.contain,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                  width: 320,
                  height: 450,
                  decoration: containerDecoration,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('SIGN IN', style: signInTitleStyle),
                      const SizedBox(height: 16),
                      TextField(
                        controller: usernameController,
                        decoration: inputDecoration('User/Email'),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: inputDecoration('Password'),
                      ),
                      const SizedBox(height: 24),
                      // ปุ่ม SIGN IN
                      SizedBox(
                        width: double.infinity, 
                        child: ElevatedButton(
                          style: loginButtonStyle,
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
                      ),

                      const SizedBox(height: 16),

                      // ปุ่ม SIGN UP
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: loginButtonStyle,
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text('SIGN UP', style: TextStyle(fontSize: 16)),
                        ),
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
