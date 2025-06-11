import 'package:medsync/data/datasources/remote/network/api_service.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final ApiService _apiService;

  DoctorRepositoryImpl(this._apiService);

  @override
  Future<List<AppointmentModel>> getDoctorAppointments({String? status, String? date}) {
    return _apiService.getDoctorAppointments(status: status, date: date);
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus(String appointmentId, String status) {
    return _apiService.updateAppointmentStatus(appointmentId, status);
  }

  @override
  Future<List<UserModel>> getDoctorPatients() {
    return _apiService.getDoctorPatients();
  }

  @override
  Future<Map<String, dynamic>> getPatientDetailsForDoctor(String patientId) {
    return _apiService.getPatientDetailsForDoctor(patientId);
  }

  @override
  Future<List<MedicalHistoryModel>> getPatientMedicalRecordsForDoctor(String patientId) {
    return _apiService.getPatientMedicalRecordsForDoctor(patientId);
  }

  @override
  Future<MedicalHistoryModel> getMedicalRecordDetails(String recordId) {
    return _apiService.getMedicalRecordDetails(recordId);
  }

  @override
  Future<MedicalHistoryModel> createMedicalRecord({required String patientId, required String diagnosis, required String treatment, String? notes}) {
    return _apiService.createMedicalRecord(patientId: patientId, diagnosis: diagnosis, treatment: treatment, notes: notes);
  }

  @override
  Future<MedicalHistoryModel> updateMedicalRecord(String recordId, {String? diagnosis, String? treatment, String? notes}) {
    return _apiService.updateMedicalRecord(recordId, diagnosis: diagnosis, treatment: treatment, notes: notes);
  }

  @override
  Future<void> deleteMedicalRecord(String recordId) {
    return _apiService.deleteMedicalRecord(recordId);
  }

  @override
  Future<List<PrescriptionModel>> getPatientPrescriptionsForDoctor(String patientId) {
    return _apiService.getPatientPrescriptionsForDoctor(patientId);
  }

  @override
  Future<PrescriptionModel> getPrescriptionDetails(String prescriptionId) {
    return _apiService.getPrescriptionDetails(prescriptionId);
  }

  @override
  Future<PrescriptionModel> createPrescription({required String patientId, required List<Map<String, dynamic>> medications}) {
    return _apiService.createPrescription(patientId: patientId, medications: medications);
  }

  @override
  Future<PrescriptionModel> updatePrescription(String prescriptionId, {required List<Map<String, dynamic>> medications}) {
    return _apiService.updatePrescription(prescriptionId, medications: medications);
  }

  @override
  Future<void> deletePrescription(String prescriptionId) {
    return _apiService.deletePrescription(prescriptionId);
  }
} 