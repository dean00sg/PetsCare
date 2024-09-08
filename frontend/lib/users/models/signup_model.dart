// lib/models/signup_model.dart

class SignupModel {
  final String firstName;  // ใช้ firstName
  final String lastName;   // ใช้ lastName
  final String email;
  final String password;
  final String contactNumber;  
  final String role = "userpets"; 

  SignupModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.contactNumber,
    
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,   
      'last_name': lastName,     
      'email': email,
      'password': password,
      'contact_number': contactNumber,  
      "role": role,
    };
  }

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      firstName: json['first_name'],   
      lastName: json['last_name'],     
      email: json['email'],
      password: json['password'],
      contactNumber: json['contact_number'], 
       
    );
  }
}
