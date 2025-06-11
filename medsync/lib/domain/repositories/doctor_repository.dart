import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/data/models/user_model.dart';

abstract class DoctorRepository {
  Future<List<AppointmentModel>> getDoctorAppointments({String? status, String? date});
  Future<AppointmentModel> updateAppointmentStatus(String appointmentId, String status);
  Future<List<UserModel>> getDoctorPatients();
  Future<Map<String, dynamic>> getPatientDetailsForDoctor(String patientId);
  Future<List<MedicalHistoryModel>> getPatientMedicalRecordsForDoctor(String patientId);
  Future<MedicalHistoryModel> getMedicalRecordDetails(String recordId);
  Future<MedicalHistoryModel> createMedicalRecord({required String patientId, required String diagnosis, required String treatment, String? notes});
  Future<MedicalHistoryModel> updateMedicalRecord(String recordId, {String? diagnosis, String? treatment, String? notes});
  Future<void> deleteMedicalRecord(String recordId);
  Future<List<PrescriptionModel>> getPatientPrescriptionsForDoctor(String patientId);
  Future<PrescriptionModel> getPrescriptionDetails(String prescriptionId);
  Future<PrescriptionModel> createPrescription({required String patientId, required List<Map<String, dynamic>> medications});
  Future<PrescriptionModel> updatePrescription(String prescriptionId, {required List<Map<String, dynamic>> medications});
  Future<void> deletePrescription(String prescriptionId);
} 