class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['contact_number'],
    );
  }
}
