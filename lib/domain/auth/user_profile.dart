class UserProfile {
  final String id;
  final String? email;
  final String role;

  const UserProfile({required this.id, this.email, required this.role});

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      email: map['email'] as String?,
      role: map['role'] as String,
    );
  }
}