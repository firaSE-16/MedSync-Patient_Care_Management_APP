import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/dashboard_stats_model.dart';
import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';

abstract class PatientRepository {
  Future<PatientDashboardData> getPatientDashboard();
  Future<List<AppointmentModel>> getPatientAppointments({String? status, bool? upcoming});
  Future<List<BookingModel>> getPatientBookings({String? status});
  Future<BookingModel> createBooking({
    required String lookingFor,
    required String preferredDate,
    required String preferredTime,
    String? priority,
    String? notes,
    String? patientName,
  });
  Future<BookingModel> cancelBooking(String bookingId);
  Future<List<PrescriptionModel>> getPatientPrescriptions();
  Future<List<UserModel>> getPatientDoctors(); // Doctors previously associated with the patient
  Future<List<MedicalHistoryModel>> getPatientMedicalHistory();
  Future<List<MedicalHistoryModel>> getPatientMedicalRecords();
}