import 'package:medsync/data/datasources/remote/network/api_service.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/domain/repositories/triage_repository.dart';

class TriageRepositoryImpl implements TriageRepository {
  final ApiService _apiService;
  TriageRepositoryImpl(this._apiService);

  @override
  Future<List<BookingModel>> getUnassignedBookings({int page = 1, int limit = 10}) async {
    return await _apiService.getUnassignedBookings(page: page, limit: limit);
  }

  @override
  Future<List<UserModel>> getAvailableDoctors({String? department}) async {
    return await _apiService.getAvailableDoctors(department: department);
  }

  @override
  Future<Map<String, dynamic>> processTriage({
    required String bookingId,
    required String doctorId,
    required Map<String, dynamic> vitals,
    required String priority,
    String? notes,
  }) async {
    return await _apiService.processTriage(
      bookingId: bookingId,
      doctorId: doctorId,
      vitals: vitals,
      priority: priority,
      notes: notes,
    );
  }

  @override
  Future<MedicalHistoryModel> updateMedicalHistory({
    required String patientId,
    Map<String, dynamic>? updateData,
  }) async {
    return await _apiService.updateMedicalHistory(patientId: patientId, updateData: updateData);
  }

  @override
  Future<List<UserModel>> getTriagePatients({String? department}) async {
    return await _apiService.getTriagePatients(department: department);
  }
} 