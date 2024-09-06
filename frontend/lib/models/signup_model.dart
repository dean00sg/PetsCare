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
}
