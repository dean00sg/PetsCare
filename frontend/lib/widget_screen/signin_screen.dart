import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png'), // Make sure you have this image in the assets folder
            const TextField(
              decoration: InputDecoration(labelText: 'FirstName'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'LastName'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/feed');
              },
              child: const Text('SIGN UP'),
            ),
          ],
        ),
      ),
    );
  }
}
