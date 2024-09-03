import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      body: Center(
        child: SingleChildScrollView( // Allows scrolling when keyboard is open
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Adding some spacing for aesthetics
              const SizedBox(height: 30),

              // Centering the image horizontally
              Image.asset(
                'lib/images/logo.png',
                height: 150, // Adjust height as needed
                width: 150,  // Adjust width as needed
                fit: BoxFit.contain,
              ),

              // Adding space between the logo and text fields
              const SizedBox(height: 30),

              // Email text field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'User/Email',
                  border: OutlineInputBorder(), // Adding border to the text field
                ),
              ),

              // Adding space between text fields
              const SizedBox(height: 20),

              // Password text field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(), // Adding border to the text field
                ),
                obscureText: true,
              ),

              // Adding space before the login button
              const SizedBox(height: 30),

              // Login button
              SizedBox(
                width: double.infinity, // Makes button full width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/feed');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded button corners
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 18), // Larger font for button
                  ),
                ),
              ),

              // Adding space between buttons
              const SizedBox(height: 20),

              // Sign In button
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(fontSize: 16, color: Colors.blue), // Blue text color for link
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
