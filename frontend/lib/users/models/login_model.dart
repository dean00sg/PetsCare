class LoginModel {
  final String username;
  final String password;
  final String role;

  LoginModel({required this.username, required this.password, this.role = ''});
}
