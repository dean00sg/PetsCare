import 'package:flutter/material.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PetScreenState createState() => _PetScreenState();
}
class _PetScreenState extends State<CreatePetScreen> {
  // ignore: prefer_final_fields
  TextEditingController _dateController = TextEditingController(); // Controller สำหรับวันที่
  // ฟังก์ชันสำหรับแสดง DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // วันที่เริ่มต้น
      firstDate: DateTime(1900),   // วันที่แรกที่สามารถเลือกได้
      lastDate: DateTime.now(),    // วันที่สุดท้ายที่สามารถเลือกได้
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // แสดงวันที่ที่เลือกใน TextField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('CREATE MY PET', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 230, 225, 225),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 500,
              height: 600,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 83, 65), 
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color.fromARGB(255, 230, 225, 225), width: 8), // ทำให้ Container มีรูปร่างเป็นวงกลม
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/images/my_cat.jpg',
                        height: 120, // ขนาดของรูปภาพ
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 122, 83, 65), 
                          borderRadius: BorderRadius.circular(25), // มุมโค้งของ Container
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, 
                                hintText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            TextField(
                              controller: _dateController, // ใช้ controller ในการแสดงวันที่ที่เลือก
                              readOnly: true, // ป้องกันไม่ให้พิมพ์ในช่องนี้
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, 
                                hintText: 'Date of Birth',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onTap: () {
                                _selectDate(context); // แสดง date picker เมื่อกด TextField
                              },
                            ),
                            const SizedBox(height: 25),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, 
                                hintText: 'Weight',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, // Background color of the text field
                                hintText: 'Sex',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: <String>['Male', 'Female'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Handle change in selected value
                              },
                            ),
                            const SizedBox(height: 25),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, // Background color of the text field
                                hintText: 'Breed',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
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
                              child: const Text('SAVE', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
