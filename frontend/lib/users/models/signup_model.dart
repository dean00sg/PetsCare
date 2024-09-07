// lib/models/signup_model.dart

class SignupModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;

  SignupModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
  });


  // ฟังก์ชันสำหรับแปลงโมเดลเป็น JSON (ถ้าจำเป็น)
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  // ฟังก์ชันสำหรับสร้างโมเดลจาก JSON (ถ้าจำเป็น)
  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}
