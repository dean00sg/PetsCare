import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Centering the image horizontally
              Image.asset(
                'lib/images/logo.png',
                height: 150, // Adjust height as needed
                width: 150,  // Adjust width as needed
                fit: BoxFit.contain,
              ),

              // Adding space between the logo and text fields
              const SizedBox(height: 30),

              // Text Field for First Name
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.brown[200], // Background color of the text field
                  hintText: 'FirstName',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Text Field for Last Name
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.brown[200], // Background color of the text field
                  hintText: 'LastName',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Text Field for Email
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.brown[200], // Background color of the text field
                  hintText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Text Field for Password
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.brown[200], // Background color of the text field
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Text Field for Phone Number
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.brown[200], // Background color of the text field
                  hintText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign Up Button
              SizedBox(
                width: double.infinity, // Full-width button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Button color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Handle sign up logic here
                  },
                  child: const Text('LOGIN', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
