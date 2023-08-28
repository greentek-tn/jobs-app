class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String phone;
  final String image;
    final String password;
  final String role;

  User( {
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phone,
    required this.image,
    required this.password, required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'], password: json['password'], role: json['role'],

    );
  }


  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
