import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String bookingId;
  final String patientId;
  final String doctorId;
  final String date;
  final String time;
  final String status;
  final String? reason;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? patientName; // Added for populated data
  final String? doctorName; // Added for populated data
  final String? doctorSpecialization; // Added for populated data

  const AppointmentEntity({
    required this.id,
    required this.bookingId,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.status,
    this.reason,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.patientName,
    this.doctorName,
    this.doctorSpecialization,
  });

  @override
  List<Object?> get props => [
        id,
        bookingId,
        patientId,
        doctorId,
        date,
        time,
        status,
        reason,
        notes,
        createdAt,
        updatedAt,
        patientName,
        doctorName,
        doctorSpecialization,
      ];
}