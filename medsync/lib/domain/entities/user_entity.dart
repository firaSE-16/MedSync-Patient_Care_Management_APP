class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? token; // Made nullable
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? emergencyContactName;
  final String? emergencyContactNumber;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.emergencyContactName,
    this.emergencyContactNumber,
  });
}