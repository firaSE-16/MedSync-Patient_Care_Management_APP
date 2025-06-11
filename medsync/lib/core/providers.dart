import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/datasources/remote/network/api_service.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/presentation/features/auth/viewmodels/auth_viewmodel.dart';

// Admin Imports
import 'package:medsync/data/repositories/admin_repository_impl.dart';
import 'package:medsync/domain/repositories/admin_repository.dart';
import 'package:medsync/domain/usecases/get_appointments_by_status_usecase.dart';
import 'package:medsync/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:medsync/domain/usecases/get_patients_usecase.dart';
import 'package:medsync/domain/usecases/get_staff_by_category_usecase.dart';
import 'package:medsync/domain/usecases/register_staff_usecase.dart';

// Patient Imports
import 'package:medsync/data/repositories/patient_repository_impl.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';
import 'package:medsync/domain/usecases/patient/cancel_booking_usecase.dart';
import 'package:medsync/domain/usecases/patient/create_booking_usecase.dart';
import 'package:medsync/domain/usecases/patient/get_patient_appointments_usecase.dart';
import 'package:medsync/domain/usecases/patient/get_patient_dashboard_usecase.dart';
import 'package:medsync/domain/usecases/patient/get_patient_doctors_usecase.dart';
import 'package:medsync/domain/usecases/patient/get_patient_prescriptions_usecase.dart';

// --- Triage Module Providers ---
import 'package:medsync/data/repositories/triage_repository_impl.dart';
import 'package:medsync/domain/repositories/triage_repository.dart';
import 'package:medsync/domain/usecases/triage/get_unassigned_bookings_usecase.dart';
import 'package:medsync/domain/usecases/triage/get_available_doctors_usecase.dart';
import 'package:medsync/domain/usecases/triage/process_triage_usecase.dart';
import 'package:medsync/domain/usecases/triage/update_medical_history_usecase.dart';
import 'package:medsync/domain/usecases/triage/get_triage_patients_usecase.dart';

// --- Doctor Module Imports ---
import 'package:medsync/data/repositories/doctor_repository_impl.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';
import 'package:medsync/domain/usecases/doctor/get_doctor_appointments_usecase.dart';
import 'package:medsync/domain/usecases/doctor/update_appointment_status_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_doctor_patients_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_patient_details_for_doctor_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_patient_medical_records_for_doctor_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_medical_record_details_usecase.dart';
import 'package:medsync/domain/usecases/doctor/create_medical_record_usecase.dart';
import 'package:medsync/domain/usecases/doctor/update_medical_record_usecase.dart';
import 'package:medsync/domain/usecases/doctor/delete_medical_record_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_patient_prescriptions_for_doctor_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_prescription_details_usecase.dart';
import 'package:medsync/domain/usecases/doctor/create_prescription_usecase.dart';
import 'package:medsync/domain/usecases/doctor/update_prescription_usecase.dart';
import 'package:medsync/domain/usecases/doctor/delete_prescription_usecase.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_appointments_viewmodel.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_patients_viewmodel.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_patient_detail_viewmodel.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_create_medical_record_viewmodel.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_edit_medical_record_viewmodel.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_create_prescription_viewmodel.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_edit_prescription_viewmodel.dart';

// --- Core Providers ---
// API Service Provider - Now ensures it's a singleton without creating a new instance
final apiServiceProvider = Provider((ref) => ApiService());

// Auth Provider
final authProvider = StateNotifierProvider<AuthViewModel, AsyncValue<UserModel?>>((ref) {
  final registerUseCase = ref.watch(registerPatientUseCaseProvider);
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return AuthViewModel(registerUseCase, loginUseCase);
});

// --- Admin Module Providers ---

// Admin Repository Provider
final adminRepositoryProvider = Provider<AdminRepository>(
    (ref) => AdminRepositoryImpl(ref.read(apiServiceProvider)));

// Admin Use Case Providers
final registerStaffUseCaseProvider = Provider(
    (ref) => RegisterStaffUseCase(ref.read(adminRepositoryProvider)));

final getStaffByCategoryUseCaseProvider = Provider(
    (ref) => GetStaffByCategoryUseCase(ref.read(adminRepositoryProvider)));

final getDashboardStatsUseCaseProvider = Provider(
    (ref) => GetDashboardStatsUseCase(ref.read(adminRepositoryProvider)));

final getAppointmentsByStatusUseCaseProvider = Provider(
    (ref) => GetAppointmentsByStatusUseCase(ref.read(adminRepositoryProvider)));

final getPatientsUseCaseProvider = Provider(
    (ref) => GetPatientsUseCase(ref.read(adminRepositoryProvider)));


// --- Patient Module Providers ---

// Patient Repository Provider
final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PatientRepositoryImpl(apiService);
});

// Patient Use Case Providers
final getPatientDashboardUseCaseProvider = Provider<GetPatientDashboardUseCase>((ref) {
  final repository = ref.read(patientRepositoryProvider);
  return GetPatientDashboardUseCase(repository);
});

final getPatientAppointmentsUseCaseProvider = Provider<GetPatientAppointmentsUseCase>((ref) {
  final repository = ref.read(patientRepositoryProvider);
  return GetPatientAppointmentsUseCase(repository);
});

final getPatientPrescriptionsUseCaseProvider = Provider<GetPatientPrescriptionsUseCase>((ref) {
  final repository = ref.read(patientRepositoryProvider);
  return GetPatientPrescriptionsUseCase(repository);
});

final getPatientDoctorsUseCaseProvider = Provider<GetPatientDoctorsUseCase>((ref) {
  final repository = ref.read(patientRepositoryProvider);
  return GetPatientDoctorsUseCase(repository);
});

final createBookingUseCaseProvider = Provider<CreateBookingUseCase>((ref) {
  final repository = ref.read(patientRepositoryProvider);
  return CreateBookingUseCase(repository);
});

final cancelBookingUseCaseProvider = Provider<CancelBookingUseCase>((ref) {
  final repository = ref.read(patientRepositoryProvider);
  return CancelBookingUseCase(repository);
});

// Patient Bookings Provider
final patientBookingsProvider = FutureProvider.family<List<BookingModel>, String?>((ref, status) async {
  final repository = ref.read(patientRepositoryProvider);
  return await repository.getPatientBookings(status: status);
});

// --- Triage Module Providers ---
final triageRepositoryProvider = Provider<TriageRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return TriageRepositoryImpl(apiService);
});

final getUnassignedBookingsUseCaseProvider = Provider<GetUnassignedBookingsUseCase>((ref) {
  final repository = ref.read(triageRepositoryProvider);
  return GetUnassignedBookingsUseCase(repository);
});

final getAvailableDoctorsUseCaseProvider = Provider<GetAvailableDoctorsUseCase>((ref) {
  final repository = ref.read(triageRepositoryProvider);
  return GetAvailableDoctorsUseCase(repository);
});

final processTriageUseCaseProvider = Provider<ProcessTriageUseCase>((ref) {
  final repository = ref.read(triageRepositoryProvider);
  return ProcessTriageUseCase(repository);
});

final updateMedicalHistoryUseCaseProvider = Provider<UpdateMedicalHistoryUseCase>((ref) {
  final repository = ref.read(triageRepositoryProvider);
  return UpdateMedicalHistoryUseCase(repository);
});

final getTriagePatientsUseCaseProvider = Provider<GetTriagePatientsUseCase>((ref) {
  final repository = ref.read(triageRepositoryProvider);
  return GetTriagePatientsUseCase(repository);
});

// --- Doctor Module Providers ---

// Doctor Repository Provider
final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DoctorRepositoryImpl(apiService);
});

// Doctor Use Case Providers
final getDoctorAppointmentsUseCaseProvider = Provider<GetDoctorAppointmentsUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return GetDoctorAppointmentsUseCase(repository);
});

final updateAppointmentStatusUseCaseProvider = Provider<UpdateAppointmentStatusUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return UpdateAppointmentStatusUseCase(repository);
});

final getDoctorPatientsUseCaseProvider = Provider<GetDoctorPatientsUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return GetDoctorPatientsUseCase(repository);
});

final getPatientDetailsForDoctorUseCaseProvider = Provider<GetPatientDetailsForDoctorUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return GetPatientDetailsForDoctorUseCase(repository);
});

final getPatientMedicalRecordsForDoctorUseCaseProvider = Provider<GetPatientMedicalRecordsForDoctorUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return GetPatientMedicalRecordsForDoctorUseCase(repository);
});

final getMedicalRecordDetailsUseCaseProvider = Provider<GetMedicalRecordDetailsUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return GetMedicalRecordDetailsUseCase(repository);
});

final createMedicalRecordUseCaseProvider = Provider<CreateMedicalRecordUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return CreateMedicalRecordUseCase(repository);
});

final updateMedicalRecordUseCaseProvider = Provider<UpdateMedicalRecordUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return UpdateMedicalRecordUseCase(repository);
});

final deleteMedicalRecordUseCaseProvider = Provider<DeleteMedicalRecordUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return DeleteMedicalRecordUseCase(repository);
});

final getPatientPrescriptionsForDoctorUseCaseProvider = Provider<GetPatientPrescriptionsForDoctorUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return GetPatientPrescriptionsForDoctorUseCase(repository);
});

final getPrescriptionDetailsUseCaseProvider = Provider<GetPrescriptionDetailsUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return GetPrescriptionDetailsUseCase(repository);
});

final createPrescriptionUseCaseProvider = Provider<CreatePrescriptionUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return CreatePrescriptionUseCase(repository);
});

final updatePrescriptionUseCaseProvider = Provider<UpdatePrescriptionUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return UpdatePrescriptionUseCase(repository);
});

final deletePrescriptionUseCaseProvider = Provider<DeletePrescriptionUseCase>((ref) {
  final repository = ref.read(doctorRepositoryProvider);
  return DeletePrescriptionUseCase(repository);
});

// Doctor ViewModel Providers
final doctorAppointmentsViewModelProvider = StateNotifierProvider<DoctorAppointmentsViewModel, AsyncValue<List<AppointmentModel>>>((ref) {
  final getAppointments = ref.watch(getDoctorAppointmentsUseCaseProvider);
  final updateStatus = ref.watch(updateAppointmentStatusUseCaseProvider);
  return DoctorAppointmentsViewModel(getAppointments, updateStatus);
});

final doctorPatientsViewModelProvider = StateNotifierProvider<DoctorPatientsViewModel, AsyncValue<List<UserModel>>>((ref) {
  final getPatients = ref.watch(getDoctorPatientsUseCaseProvider);
  return DoctorPatientsViewModel(getPatients);
});

final doctorPatientDetailViewModelProvider = StateNotifierProvider.family<DoctorPatientDetailViewModel, AsyncValue<void>, String>((ref, patientId) {
  final getPatientDetails = ref.watch(getPatientDetailsForDoctorUseCaseProvider);
  final getMedicalRecords = ref.watch(getPatientMedicalRecordsForDoctorUseCaseProvider);
  final getMedicalRecordDetails = ref.watch(getMedicalRecordDetailsUseCaseProvider);
  final createMedicalRecord = ref.watch(createMedicalRecordUseCaseProvider);
  final updateMedicalRecord = ref.watch(updateMedicalRecordUseCaseProvider);
  final deleteMedicalRecord = ref.watch(deleteMedicalRecordUseCaseProvider);
  final getPrescriptions = ref.watch(getPatientPrescriptionsForDoctorUseCaseProvider);
  final getPrescriptionDetails = ref.watch(getPrescriptionDetailsUseCaseProvider);
  final createPrescription = ref.watch(createPrescriptionUseCaseProvider);
  final updatePrescription = ref.watch(updatePrescriptionUseCaseProvider);
  final deletePrescription = ref.watch(deletePrescriptionUseCaseProvider);

  return DoctorPatientDetailViewModel(
    patientId,
    getPatientDetails,
    getMedicalRecords,
    getMedicalRecordDetails,
    createMedicalRecord,
    updateMedicalRecord,
    deleteMedicalRecord,
    getPrescriptions,
    getPrescriptionDetails,
    createPrescription,
    updatePrescription,
    deletePrescription,
  );
});

final doctorCreateMedicalRecordViewModelProvider = StateNotifierProvider<DoctorCreateMedicalRecordViewModel, AsyncValue<void>>((ref) {
  final createMedicalRecord = ref.watch(createMedicalRecordUseCaseProvider);
  return DoctorCreateMedicalRecordViewModel(createMedicalRecord);
});

final doctorEditMedicalRecordViewModelProvider = StateNotifierProvider.family<DoctorEditMedicalRecordViewModel, AsyncValue<void>, String>((ref, recordId) {
  final updateMedicalRecord = ref.watch(updateMedicalRecordUseCaseProvider);
  final getMedicalRecordDetails = ref.watch(getMedicalRecordDetailsUseCaseProvider);
  return DoctorEditMedicalRecordViewModel(recordId, updateMedicalRecord, getMedicalRecordDetails);
});

final doctorCreatePrescriptionViewModelProvider = StateNotifierProvider<DoctorCreatePrescriptionViewModel, AsyncValue<void>>((ref) {
  final createPrescription = ref.watch(createPrescriptionUseCaseProvider);
  return DoctorCreatePrescriptionViewModel(createPrescription);
});

final doctorEditPrescriptionViewModelProvider = StateNotifierProvider.family<DoctorEditPrescriptionViewModel, AsyncValue<void>, String>((ref, prescriptionId) {
  final updatePrescription = ref.watch(updatePrescriptionUseCaseProvider);
  final getPrescriptionDetails = ref.watch(getPrescriptionDetailsUseCaseProvider);
  return DoctorEditPrescriptionViewModel(prescriptionId, updatePrescription, getPrescriptionDetails);
});