import 'package:dio/dio.dart';
import 'package:medsync/data/datasources/remote/network/dio_client.dart'; // Assuming DioClient handles base URL and interceptors
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/dashboard_stats_model.dart'; // For PatientDashboardData
import 'package:medsync/data/models/prescription_model.dart'; // For PrescriptionModel
import 'package:medsync/data/models/booking_model.dart'; // For BookingModel
import 'package:medsync/data/models/medical_history_model.dart'; // For MedicalHistoryModel

class ApiService {
  final Dio _dio = DioClient().dio; 
  
  Future<UserModel> registerPatient(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/register/patient', data: data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> login(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/login', data: data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Admin Endpoints (Your Existing) ---
  Future<UserModel> registerStaff(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/admin/staff', data: data);
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getStaffByCategory(String role, {String? search}) async {
    try {
      final response = await _dio.get(
        '/admin/staff/$role',
        queryParameters: {'search': search},
      );
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList();
      }
      throw 'Failed to fetch staff';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _dio.get('/admin/dashboard-stats');
      if (response.data['success']) {
        return response.data['data'];
      }
      throw 'Failed to fetch dashboard stats';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByStatus(
      {String? status, int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/admin/appointments',
        queryParameters: {'status': status, 'page': page, 'limit': limit},
      );
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => AppointmentModel.fromJson(e))
            .toList();
      }
      throw 'Failed to fetch appointments';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getPatients(
      {int page = 1, int limit = 10, String? search}) async {
    try {
      final response = await _dio.get(
        '/admin/patients',
        queryParameters: {'page': page, 'limit': limit, 'search': search},
      );
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList();
      }
      throw 'Failed to fetch patients';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Patient Endpoints (Added Directly) ---
  Future<PatientDashboardData> getPatientDashboard() async {
    try {
      final response = await _dio.get('/patient/dashboard');
      if (response.statusCode == 200 && response.data['success']) {
        return PatientDashboardData.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to load patient dashboard data';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<AppointmentModel>> getPatientAppointments({String? status, bool? upcoming}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['status'] = status;
      if (upcoming != null) queryParameters['upcoming'] = upcoming.toString();

      final response = await _dio.get('/patient/appointments', queryParameters: queryParameters);
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load patient appointments';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<BookingModel>> getPatientBookings({String? status}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['status'] = status;

      final response = await _dio.get('/patient/bookings', queryParameters: queryParameters);
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load patient bookings';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> createPatientBooking({
    required String lookingFor,
    required String preferredDate,
    required String preferredTime,
    String? priority,
    String? notes,
    String? patientName,
  }) async {
    try {
      final data = {
        'lookingFor': lookingFor,
        'preferredDate': preferredDate,
        'preferredTime': preferredTime,
        if (priority != null) 'priority': priority,
        if (notes != null) 'notes': notes,
        if (patientName != null) 'patientName': patientName,
      };
      final response = await _dio.post('/patient/bookings', data: data);
      if (response.statusCode == 201 && response.data['success']) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to create patient booking';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> cancelPatientBooking(String bookingId) async {
    try {
      final response = await _dio.put('/patient/bookings/$bookingId/cancel');
      if (response.statusCode == 200 && response.data['success']) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to cancel patient booking';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PrescriptionModel>> getPatientPrescriptions() async {
    try {
      final response = await _dio.get('/patient/prescriptions');
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load patient prescriptions';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<MedicalHistoryModel>> getPatientMedicalHistory() async {
    try {
      final response = await _dio.get('/patient/medical-history');
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => MedicalHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load medical history';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<MedicalHistoryModel>> getPatientMedicalRecords() async {
    try {
      final response = await _dio.get('/patient/medical-records');
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => MedicalHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load medical records';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getPatientDoctors() async {
    try {
      final response = await _dio.get('/patient/doctors');
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load patient doctors';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Triage Endpoints ---
  Future<List<BookingModel>> getUnassignedBookings({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get('/triage/bookings', queryParameters: {'page': page, 'limit': limit});
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load unassigned bookings';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getAvailableDoctors({String? department}) async {
    try {
      final response = await _dio.get('/triage/doctors', queryParameters: {'department': department});
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load available doctors';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> processTriage({
    required String bookingId,
    required String doctorId,
    required Map<String, dynamic> vitals,
    required String priority,
    String? notes,
  }) async {
    try {
      final data = {
        'doctorId': doctorId,
        'vitals': vitals,
        'priority': priority,
        if (notes != null) 'notes': notes,
      };
      final response = await _dio.post('/triage/process/$bookingId', data: data);
      if (response.statusCode == 201 && response.data['success']) {
        return response.data['data'];
      } else {
        throw response.data['message'] ?? 'Failed to process triage';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicalHistoryModel> updateMedicalHistory({
    required String patientId,
    Map<String, dynamic>? updateData,
  }) async {
    try {
      final response = await _dio.put('/triage/medical-history/$patientId', data: updateData ?? {});
      if (response.statusCode == 200 && response.data['success']) {
        return MedicalHistoryModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to update medical history';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getTriagePatients({String? department}) async {
    try {
      final response = await _dio.get('/triage/patients', queryParameters: {'department': department});
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load triage patients';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Doctor Endpoints ---

  Future<List<AppointmentModel>> getDoctorAppointments({String? status, String? date}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['status'] = status;
      if (date != null) queryParameters['date'] = date;

      final response = await _dio.get('/doctor/appointments', queryParameters: queryParameters);
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load doctor appointments';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AppointmentModel> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      final response = await _dio.put('/doctor/appointments/$appointmentId/status', data: {'status': status});
      if (response.statusCode == 200 && response.data['success']) {
        return AppointmentModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to update appointment status';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getDoctorPatients() async {
    try {
      final response = await _dio.get('/doctor/patients');
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load doctor patients';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getPatientDetailsForDoctor(String patientId) async {
    try {
      final response = await _dio.get('/doctor/patients/$patientId');
      if (response.statusCode == 200 && response.data['success']) {
        
        return response.data['data'];
      } else {
        throw response.data['message'] ?? 'Failed to load patient details';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<MedicalHistoryModel>> getPatientMedicalRecordsForDoctor(String patientId) async {
    try {
      final response = await _dio.get('/doctor/patients/$patientId/medical-records');
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => MedicalHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load patient medical records';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicalHistoryModel> getMedicalRecordDetails(String recordId) async {
    try {
      final response = await _dio.get('/doctor/medical-records/$recordId');
      if (response.statusCode == 200 && response.data['success']) {
        return MedicalHistoryModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to load medical record details';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicalHistoryModel> createMedicalRecord({required String patientId, required String diagnosis, required String treatment, String? notes}) async {
    try {
      final data = {
        'patientId': patientId,
        'diagnosis': diagnosis,
        'treatment': treatment,
        if (notes != null) 'notes': notes,
      };
      final response = await _dio.post('/doctor/medical-records', data: data);
      if (response.statusCode == 201 && response.data['success']) {
        return MedicalHistoryModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to create medical record';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicalHistoryModel> updateMedicalRecord(String recordId, {String? diagnosis, String? treatment, String? notes}) async {
    try {
      final data = {
        if (diagnosis != null) 'diagnosis': diagnosis,
        if (treatment != null) 'treatment': treatment,
        if (notes != null) 'notes': notes,
      };
      final response = await _dio.put('/doctor/medical-records/$recordId', data: data);
      if (response.statusCode == 200 && response.data['success']) {
        return MedicalHistoryModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to update medical record';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteMedicalRecord(String recordId) async {
    try {
      final response = await _dio.delete('/doctor/medical-records/$recordId');
      if (response.statusCode != 200 || !response.data['success']) {
        throw response.data['message'] ?? 'Failed to delete medical record';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PrescriptionModel>> getPatientPrescriptionsForDoctor(String patientId) async {
    try {
      final response = await _dio.get('/doctor/patients/$patientId/prescriptions');
      if (response.statusCode == 200 && response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw response.data['message'] ?? 'Failed to load patient prescriptions';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PrescriptionModel> getPrescriptionDetails(String prescriptionId) async {
    try {
      final response = await _dio.get('/doctor/prescriptions/$prescriptionId');
      if (response.statusCode == 200 && response.data['success']) {
        return PrescriptionModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to load prescription details';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PrescriptionModel> createPrescription({required String patientId, required List<Map<String, dynamic>> medications}) async {
    try {
      final data = {
        'patientId': patientId,
        'medications': medications,
      };
      final response = await _dio.post('/doctor/prescriptions', data: data);
      if (response.statusCode == 201 && response.data['success']) {
        return PrescriptionModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to create prescription';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PrescriptionModel> updatePrescription(String prescriptionId, {required List<Map<String, dynamic>> medications}) async {
    try {
      final data = {
        'medications': medications,
      };
      final response = await _dio.put('/doctor/prescriptions/$prescriptionId', data: data);
      if (response.statusCode == 200 && response.data['success']) {
        return PrescriptionModel.fromJson(response.data['data']);
      } else {
        throw response.data['message'] ?? 'Failed to update prescription';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePrescription(String prescriptionId) async {
    try {
      final response = await _dio.delete('/doctor/prescriptions/$prescriptionId');
      if (response.statusCode != 200 || !response.data['success']) {
        throw response.data['message'] ?? 'Failed to delete prescription';
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Error Handling ---
  String _handleError(DioException e) {
    if (e.response != null) {
      // Prioritize backend message if available
      return e.response!.data['message'] ?? 'An API error occurred: ${e.response!.statusCode}';
    }
    // Fallback for network issues or unexpected errors
    return 'Network error: ${e.message ?? 'Unknown error'}';
  }
}