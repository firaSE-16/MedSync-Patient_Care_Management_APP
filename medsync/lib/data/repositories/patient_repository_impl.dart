import 'package:dio/dio.dart';
// Note: api_endpoints.dart is intentionally removed as per previous instructions
import 'package:medsync/data/datasources/remote/network/api_service.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/dashboard_stats_model.dart';
import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  final ApiService _apiService;

  PatientRepositoryImpl(this._apiService);

  @override
  Future<PatientDashboardData> getPatientDashboard() async {
    try {
      // Call the specific method on ApiService
      return await _apiService.getPatientDashboard();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error for dashboard');
    } catch (e) {
      throw Exception('An unexpected error occurred loading dashboard: $e');
    }
  }

  @override
  Future<List<AppointmentModel>> getPatientAppointments({String? status, bool? upcoming}) async {
    try {
      // Call the specific method on ApiService
      return await _apiService.getPatientAppointments(status: status, upcoming: upcoming);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error for appointments');
    } catch (e) {
      throw Exception('An unexpected error occurred loading appointments: $e');
    }
  }

  @override
  Future<List<BookingModel>> getPatientBookings({String? status}) async {
    try {
      // Call the specific method on ApiService
      return await _apiService.getPatientBookings(status: status);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error for bookings');
    } catch (e) {
      throw Exception('An unexpected error occurred loading bookings: $e');
    }
  }

  @override
  Future<BookingModel> createBooking({
    required String lookingFor,
    required String preferredDate,
    required String preferredTime,
    String? priority,
    String? notes,
    String? patientName,
  }) async {
    try {
      // Call the specific method on ApiService
      return await _apiService.createPatientBooking(
        lookingFor: lookingFor,
        preferredDate: preferredDate,
        preferredTime: preferredTime,
        priority: priority,
        notes: notes,
        patientName: patientName,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error creating booking');
     //fungicide('An unexpected error occurred creating booking: $e');
    }
  }

  @override
  Future<BookingModel> cancelBooking(String bookingId) async {
    try {
      // Call the specific method on ApiService
      return await _apiService.cancelPatientBooking(bookingId);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error cancelling booking');
    } catch (e) {
      throw Exception('An unexpected error occurred cancelling booking: $e');
    }
  }

  @override
  Future<List<PrescriptionModel>> getPatientPrescriptions() async {
    try {
      // Call the specific method on ApiService
      return await _apiService.getPatientPrescriptions();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error for prescriptions');
    } catch (e) {
      throw Exception('An unexpected error occurred loading prescriptions: $e');
    }
  }

  @override
  Future<List<UserModel>> getPatientDoctors() async {
    try {
      // Call the specific method on ApiService
      return await _apiService.getPatientDoctors();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error for doctors');
    } catch (e) {
      throw Exception('An unexpected error occurred loading doctors: $e');
    }
  }

  @override
  Future<List<MedicalHistoryModel>> getPatientMedicalHistory() async {
    try {
      return await _apiService.getPatientMedicalHistory();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error for medical history');
    } catch (e) {
      throw Exception('An unexpected error occurred loading medical history: $e');
    }
  }

  @override
  Future<List<MedicalHistoryModel>> getPatientMedicalRecords() async {
    try {
      return await _apiService.getPatientMedicalRecords();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error for medical records');
    } catch (e) {
      throw Exception('An unexpected error occurred loading medical records: $e');
    }
  }
}