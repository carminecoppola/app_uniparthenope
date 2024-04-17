class User {
  final String id;
  final String name;
  final String surname;
  final String username;
  final String password;
  final String role;

  User(
      {required this.id,
      required this.name,
      required this.surname,
      required this.username,
      required this.password,
      required this.role});

  factory User.fromJson(Map<String, dynamic> userJson) {
    return User(
        id: userJson['id'],
        name: userJson['name'],
        surname: userJson['surname'],
        username: userJson['username'],
        password: userJson['password'],
        role: userJson['role']);
  }
}