import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';

abstract class TriageRepository {
  Future<List<BookingModel>> getUnassignedBookings({int page, int limit});
  Future<List<UserModel>> getAvailableDoctors({String? department});
  Future<Map<String, dynamic>> processTriage({
    required String bookingId,
    required String doctorId,
    required Map<String, dynamic> vitals,
    required String priority,
    String? notes,
  });
  Future<MedicalHistoryModel> updateMedicalHistory({
    required String patientId,
    Map<String, dynamic>? updateData,
  });
  Future<List<UserModel>> getTriagePatients({String? department});
} 