import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึงขนาดหน้าจอปัจจุบัน
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('PET CARE', style: TextStyle(fontSize: 16, color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (String result) {
              if (result == 'profile') {
                Navigator.pushNamed(context, '/profile');
              } else if (result == 'signout') {
                Navigator.pushNamed(context, '/');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('PROFILE'),
              ),
              const PopupMenuItem<String>(
                value: 'signout',
                child: Text('SIGN OUT'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown[400],
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('PETS'),
              onTap: () {
                Navigator.pushNamed(context, '/pet');
              },
            ),
            ListTile(
              title: const Text('My Pets'),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              const Center( // ทำให้ข้อความอยู่ตรงกลาง
                child: Text(
                  'WELCOME TO PET CARE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              const Center( // ทำให้ข้อความอยู่ตรงกลาง
                child: Text(
                  'อ่านบทความสุขภาพสัตว์เลี้ยงของคุณได้ที่นี่!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              const Center( // ทำให้ข้อความอยู่ตรงกลาง
                child: Text(
                  'คุณสามารถค้นหาข้อมูลที่เป็นประโยชน์เกี่ยวกับสุขภาพและการดูแลสัตว์เลี้ยงของคุณได้ที่นี่ การรับข้อมูลที่ถูกต้องจะช่วยให้คุณดูแลสัตว์เลี้ยงของคุณให้มีสุขภาพดีและมีความสุข.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // เพิ่ม Padding ให้ content
                child: Container(
                  width: screenWidth * 0.9, // กำหนดความกว้างเป็น 90% ของหน้าจอ
                  decoration: BoxDecoration(
                    color: Colors.brown[500],
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3), // ทำให้เกิดเงา
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'ทาสแมวมือใหม่ต้องรู้เลี้ยงลูกแมวอย่างไรดี',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // รูปภาพจะถูกแสดงตามขนาดจริงโดยใช้ BoxFit.none
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * 0.85, // ขนาดสูงสุดของรูป
                          maxHeight: screenHeight * 0.4, // ความสูงสูงสุดของรูป
                        ),
                        child: Image.asset(
                          'lib/images/cat_1.jpg', // Replace with the correct image path
                          fit: BoxFit.contain, // ใช้ BoxFit.contain เพื่อคงขนาดจริง
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.all(8.0), // เพิ่ม Padding รอบข้อความ
                        child: Text(
                          'รู้หรือไม่? ว่านอกจากจะลดน้ำหนักด้วยการออกกำลังกายแล้ว ก็ยังมีวิธีง่ายๆ ช่วยให้ลดน้ำหนักได้ดี อีกหนึ่งวิธีคือ การควบคุมปริมาณ Kcal ต่อวันของอาหารที่เรากินเข้าไปนั่นเอง ซึ่งการกินแบบนับแคลอรี่นั้นจะช่วยให้ร่างกายได้รับสารอาหารเพียงพอต่อปริมาณที่ร่างกายต้องการในแต่ละวัน โดยวิธีที่เราจะมาแนะนำกันในวันนี้คือ วิธีคำนวณปริมาณแคลอรี่ ต่อวัน ด้วยสูตร Basal Metabolic Rate (BMR) หรือการหาค่าพลังงานที่ร่างกายต้องการอย่างน้อยในแต่ละวัน เพื่อให้เรากินอาหารได้อย่างเหมาะสมมากขึ้นค่ะ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
