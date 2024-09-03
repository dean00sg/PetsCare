import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 225, 225), // Light background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 500,
              height: 700,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 83, 65), // Inner container background color
                borderRadius: BorderRadius.circular(25),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Container(
                      width: 170, // ขนาดของ Container ใหญ่กว่าขนาดของรูปเล็กน้อยเพื่อเพิ่มขอบ
                      height: 170,
                      decoration: const BoxDecoration(
                        color: Colors.white, 
                        shape: BoxShape.circle, // ทำให้ Container มีรูปร่างเป็นวงกลม
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'lib/images/logo.png',
                          height: 150, // ขนาดของรูปภาพ
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    // Text Field for Email
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Background color of the text field
                        hintText: 'FristName',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Text Field for Last Name
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Background color of the text field
                        hintText: 'LastName',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Text Field for Email
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Background color of the text field
                        hintText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Text Field for Password
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Background color of the text field
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Text Field for Phone Number
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Background color of the text field
                        hintText: 'Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Sign Up Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, // Button color
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: const Text('SIGN IN', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
   );
  }
}
