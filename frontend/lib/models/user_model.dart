class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Print the incoming JSON for debugging
    print('Creating UserModel from JSON: $json');
    
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',  // Handle both _id and id
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role']?.toString().toLowerCase() ?? '', // Normalize role to lowercase
      token: json['token'],
    );
  }

  // Add copyWith method
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }
}
