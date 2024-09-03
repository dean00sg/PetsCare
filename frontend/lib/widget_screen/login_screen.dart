import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 225, 225), //กำหนดสีพื้นหลัง Scaffold
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Centering the image horizontally and vertically
            Image.asset(
              'lib/images/logo.png',
              height: 300, //ขนาดความสูง logo
              width: 300, //ขนาดความกว้าง logo
              fit: BoxFit.contain,
            ),
            // Container with increased top padding
            Container( //กล่องสำหรับ log in
              margin: const EdgeInsets.symmetric(horizontal: 20.0), //กำหนด margin ด้านซ้ายและขวา
              padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0), //กำหนด padding ของ Container ด้านซ้าย, บน, ขวา, ล่าง
              width: 350, //กำหนดความกว้าง container
              height: 400, //กำหนดความสูง container
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 83, 65), //กำหนดสีพื้นหลังของ Container
                borderRadius: BorderRadius.circular(25), //กำหนดมุมโค้งของ Container
              ),
              child: SingleChildScrollView( 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Text Field for User/Email
                    const SizedBox(height: 16), //เว้นระยะห่างระหว่าง container กับ กล่อง User/Email
                    TextField(
                      decoration: InputDecoration(
                        filled: true, //กำหนดให้ TextField มีสีพื้นหลัง
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        hintText: 'User/Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0), //กำหนดมุมโค้งของขอบ TextField
                          borderSide: BorderSide.none,  //ไม่แสดงเส้นขอบของ TextField
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), //เว้นระยะห่างระหว่าง TextField ของ User/Email กับ Password
                    // Text Field for Password
                    TextField(
                      obscureText: true, //ซ่อนข้อความที่กรอกในช่องให้เป็น ***
                      decoration: InputDecoration(
                        filled: true, //กำหนดให้ TextField มีสีพื้นหลัง
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),  //เว้นระยะห่างระหว่าง TextField ของ Password กับปุ่ม SIGN IN
                    // Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber, // Button color
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50), //กำหนดขนาดกล่องของปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24), //กำหนดมุมโค้งของปุ่ม
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/feed'); //นำไปยังหน้าฟีดเมื่อกดปุ่ม SIGN IN
                      },
                      child:
                          const Text('SIGN IN', style: TextStyle(fontSize: 16)),
                    ),
                    // Sign in Button
                    const SizedBox(height: 16), //เว้นระยะห่างระหว่างปุ่ม SIGN IN กับปุ่ม SIGN UP
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber, // Button color
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child:
                          const Text('SIGN UP', style: TextStyle(fontSize: 16)),
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
