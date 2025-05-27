enum Role {
  ORGANIZER,
  PARTICIPANT
}

class User {
  final int id;
  final String email;
  final String username;
  final Role role;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      role: Role.values.firstWhere(
        (e) => e.toString() == 'Role.${json['role']}',
        orElse: () => Role.PARTICIPANT,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'role': role.toString().split('.').last,
    };
  }

  // Create a new user for registration
  factory User.forRegistration({
    required String email,
    required String username,
  }) {
    return User(
      id: 0, // This will be set by the backend
      email: email,
      username: username,
      role: Role.PARTICIPANT, // Default role for new users
    );
  }
} 