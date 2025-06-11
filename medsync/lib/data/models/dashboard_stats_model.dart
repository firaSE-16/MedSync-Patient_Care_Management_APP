import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';

class PatientDashboardData {
  final List<AppointmentModel> upcomingAppointments;
  final List<PrescriptionModel> recentPrescriptions;
  final List<BookingModel> pendingBookings;
  final List<MedicalHistoryModel> medicalHistory;
  final List<String> allergies; // From MedicalHistory
  final List<String> conditions; // From MedicalHistory

  PatientDashboardData({
    required this.upcomingAppointments,
    required this.recentPrescriptions,
    required this.pendingBookings,
    required this.medicalHistory,
    required this.allergies,
    required this.conditions,
  });

  factory PatientDashboardData.fromJson(Map<String, dynamic> json) {
    return PatientDashboardData(
      upcomingAppointments: (json['upcomingAppointments'] as List<dynamic>?)
              ?.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentPrescriptions: (json['recentPrescriptions'] as List<dynamic>?)
              ?.map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pendingBookings: (json['pendingBookings'] as List<dynamic>?)
              ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      medicalHistory: (json['medicalHistory'] as List<dynamic>?)
              ?.map((e) => MedicalHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      conditions: (json['conditions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}