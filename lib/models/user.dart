class User {
  int id;
  String name;
  String email;
  String gender;
  bool status; 

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'] == 'true', 
    );
  }

  set setName(String newName) {
    name = newName;
  }

  set setEmail(String newEmail) {
    email = newEmail;
  }

  set setGender(String newGender) {
    gender = newGender; 
  }

  set setStatus(dynamic newStatus) {
    status = newStatus is bool ? newStatus : newStatus.toString().toLowerCase() == 'true';
  }
}
