class UserProfilePets {
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  UserProfilePets({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  factory UserProfilePets.fromJson(Map<String, dynamic> json) {
    return UserProfilePets(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      role: json['role'],
    );
  }
}
