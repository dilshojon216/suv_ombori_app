class UserModel {
  String name;
  String lastname;
  String username;
  String phone;
  String password;
  String role;

  UserModel(
      {required this.name,
      required this.lastname,
      required this.username,
      required this.phone,
      required this.password,
      required this.role});

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        lastname = json["lastname"],
        username = json["username"],
        phone = json["phone"],
        password = json["password"],
        role = json["role"];

  Map<String, String> toJson() {
    return {
      "name": name,
      "username": username,
      "lastname": lastname,
      "phone": phone,
      "password": password,
      "role": role
    };
  }

  @override
  String toString() {
    return 'UserModel(name: $name, lastname: $lastname, username: $username, phone: $phone, password: $password, role: $role)';
  }
}
