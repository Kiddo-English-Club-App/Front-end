// lib/models/profile.dart
class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String accountType;
  final String fullName;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.accountType,
    required this.fullName,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      accountType: json['account_type'] ?? 'user',
      fullName: json['full_name'] ?? '',
    );
  }
}
