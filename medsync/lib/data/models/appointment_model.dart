import 'package:medsync/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.bookingId,
    required super.patientId,
    required super.doctorId,
    required super.date,
    required super.time,
    required super.status,
    super.reason,
    super.notes,
    super.createdAt,
    super.updatedAt,
    super.patientName,
    super.doctorName, // Added for populated data
    super.doctorSpecialization, // Added for populated data
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Determine patientId: if it's a populated object, get '_id', otherwise use the string directly
    final String patientIdValue;
    if (json['patientId'] is Map) {
      patientIdValue = json['patientId']['_id'] ?? '';
    } else {
      patientIdValue = json['patientId'] ?? '';
    }

    // Determine doctorId: if it's a populated object, get '_id', otherwise use the string directly
    final String doctorIdValue;
    if (json['doctorId'] is Map) {
      doctorIdValue = json['doctorId']['_id'] ?? '';
    } else {
      doctorIdValue = json['doctorId'] ?? '';
    }

    return AppointmentModel(
      id: json['_id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      patientId: patientIdValue,
      doctorId: doctorIdValue,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      reason: json['reason'],
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      // Populated names and specialization directly from the nested objects
      patientName: json['patientId'] is Map ? json['patientId']['name'] : null,
      doctorName: json['doctorId'] is Map ? json['doctorId']['name'] : null,
      doctorSpecialization:
          json['doctorId'] is Map ? json['doctorId']['specialization'] : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // When converting to JSON, typically you'd send just the IDs back to the backend
    // unless the backend specifically expects the nested objects for updates.
    // For this example, we'll send the IDs as strings.
    return {
      '_id': id,
      'bookingId': bookingId,
      'patientId': patientId, // Sending just the ID back
      'doctorId': doctorId,   // Sending just the ID back
      'date': date,
      'time': time,
      'status': status,
      'reason': reason,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      // patientName, doctorName, doctorSpecialization are typically not sent in toJson
      // as they are derived/populated on the backend.
    };
  }
}