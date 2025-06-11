import 'package:medsync/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.token, // Make token nullable as it might not always be present from staff fetching
    super.dateOfBirth,
    super.gender,
    super.bloodGroup,
    super.emergencyContactName,
    super.emergencyContactNumber,
    // Doctor specific fields
    this.specialization,
    this.phone,
    this.rating,
    this.hospital,
    this.experienceYears,
    this.qualifications,
    this.licenseNumber,
    this.department,
    // Admin/triage specific fields
    this.position,
    this.profileImageUrl,
  });

  final String? specialization;
  final String? phone;
  final double? rating;
  final String? hospital;
  final int? experienceYears;
  final String? qualifications;
  final String? licenseNumber;
  final String? department;
  final String? position;
  final String? profileImageUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '', // Backend uses _id for MongoDB documents
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['token'], // token can be null for staff data
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactNumber: json['emergencyContactNumber'],
      // Doctor specific fields
      specialization: json['specialization'],
      phone: json['phone'],
      rating: (json['rating'] as num?)?.toDouble(),
      hospital: json['hospital'],
      experienceYears: json['experienceYears'] as int?,
      qualifications: json['qualifications'],
      licenseNumber: json['licenseNumber'],
      department: json['department'],
      // Admin/triage specific fields
      position: json['position'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
    };
    if (token != null) data['token'] = token;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth!.toIso8601String();
    if (gender != null) data['gender'] = gender;
    if (bloodGroup != null) data['bloodGroup'] = bloodGroup;
    if (emergencyContactName != null) data['emergencyContactName'] = emergencyContactName;
    if (emergencyContactNumber != null) data['emergencyContactNumber'] = emergencyContactNumber;
    if (specialization != null) data['specialization'] = specialization;
    if (phone != null) data['phone'] = phone;
    if (rating != null) data['rating'] = rating;
    if (hospital != null) data['hospital'] = hospital;
    if (experienceYears != null) data['experienceYears'] = experienceYears;
    if (qualifications != null) data['qualifications'] = qualifications;
    if (licenseNumber != null) data['licenseNumber'] = licenseNumber;
    if (department != null) data['department'] = department;
    if (position != null) data['position'] = position;
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;
    return data;
  }
}