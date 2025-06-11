import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/data/models/prescription_model.dart';
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
import 'doctor_state.dart';

class DoctorViewModel extends StateNotifier<DoctorState> {
  final GetDoctorAppointmentsUseCase _getAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase _updateAppointmentStatusUseCase;
  final GetDoctorPatientsUseCase _getPatientsUseCase;
  final GetPatientDetailsForDoctorUseCase _getPatientDetailsUseCase;
  final GetPatientMedicalRecordsForDoctorUseCase _getMedicalRecordsUseCase;
  final GetMedicalRecordDetailsUseCase _getMedicalRecordDetailsUseCase;
  final CreateMedicalRecordUseCase _createMedicalRecordUseCase;
  final UpdateMedicalRecordUseCase _updateMedicalRecordUseCase;
  final DeleteMedicalRecordUseCase _deleteMedicalRecordUseCase;
  final GetPatientPrescriptionsForDoctorUseCase _getPrescriptionsUseCase;
  final GetPrescriptionDetailsUseCase _getPrescriptionDetailsUseCase;
  final CreatePrescriptionUseCase _createPrescriptionUseCase;
  final UpdatePrescriptionUseCase _updatePrescriptionUseCase;
  final DeletePrescriptionUseCase _deletePrescriptionUseCase;

  DoctorViewModel({
    required GetDoctorAppointmentsUseCase getAppointmentsUseCase,
    required UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase,
    required GetDoctorPatientsUseCase getPatientsUseCase,
    required GetPatientDetailsForDoctorUseCase getPatientDetailsUseCase,
    required GetPatientMedicalRecordsForDoctorUseCase getMedicalRecordsUseCase,
    required GetMedicalRecordDetailsUseCase getMedicalRecordDetailsUseCase,
    required CreateMedicalRecordUseCase createMedicalRecordUseCase,
    required UpdateMedicalRecordUseCase updateMedicalRecordUseCase,
    required DeleteMedicalRecordUseCase deleteMedicalRecordUseCase,
    required GetPatientPrescriptionsForDoctorUseCase getPrescriptionsUseCase,
    required GetPrescriptionDetailsUseCase getPrescriptionDetailsUseCase,
    required CreatePrescriptionUseCase createPrescriptionUseCase,
    required UpdatePrescriptionUseCase updatePrescriptionUseCase,
    required DeletePrescriptionUseCase deletePrescriptionUseCase,
  })  : _getAppointmentsUseCase = getAppointmentsUseCase,
        _updateAppointmentStatusUseCase = updateAppointmentStatusUseCase,
        _getPatientsUseCase = getPatientsUseCase,
        _getPatientDetailsUseCase = getPatientDetailsUseCase,
        _getMedicalRecordsUseCase = getMedicalRecordsUseCase,
        _getMedicalRecordDetailsUseCase = getMedicalRecordDetailsUseCase,
        _createMedicalRecordUseCase = createMedicalRecordUseCase,
        _updateMedicalRecordUseCase = updateMedicalRecordUseCase,
        _deleteMedicalRecordUseCase = deleteMedicalRecordUseCase,
        _getPrescriptionsUseCase = getPrescriptionsUseCase,
        _getPrescriptionDetailsUseCase = getPrescriptionDetailsUseCase,
        _createPrescriptionUseCase = createPrescriptionUseCase,
        _updatePrescriptionUseCase = updatePrescriptionUseCase,
        _deletePrescriptionUseCase = deletePrescriptionUseCase,
        super(DoctorState(
          appointments: const AsyncValue.loading(),
          patients: const AsyncValue.loading(),
        )) {
    fetchAppointments();
    fetchPatients();
  }

  Future<void> fetchAppointments({String? status, String? date}) async {
    try {
      state = state.copyWith(appointments: const AsyncValue.loading());
      // Always request scheduled appointments for the doctor's home screen timeline
      final appointments = await _getAppointmentsUseCase.call(status: status ?? 'scheduled', date: date);
      state = state.copyWith(appointments: AsyncValue.data(appointments));
    } catch (e, st) {
      state = state.copyWith(appointments: AsyncValue.error(e, st));
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      final updatedAppointment = await _updateAppointmentStatusUseCase.call(appointmentId: appointmentId, status: status);
      final currentAppointments = state.appointments.value ?? [];
      final updatedAppointments = currentAppointments.map((appointment) {
        return appointment.id == appointmentId ? updatedAppointment : appointment;
      }).toList();
      state = state.copyWith(appointments: AsyncValue.data(updatedAppointments));
    } catch (e, st) {
      // Handle error
    }
  }

  Future<void> fetchPatients() async {
    try {
      state = state.copyWith(patients: const AsyncValue.loading());
      final patients = await _getPatientsUseCase.call();
      state = state.copyWith(patients: AsyncValue.data(patients));
    } catch (e, st) {
      state = state.copyWith(patients: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchPatientDetails(String patientId) async {
    try {
      state = state.copyWith(selectedPatient: const AsyncValue.loading());
      final patientDetails = await _getPatientDetailsUseCase.call(patientId: patientId);
      state = state.copyWith(selectedPatient: AsyncValue.data(patientDetails));
    } catch (e, st) {
      state = state.copyWith(selectedPatient: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchPatientMedicalRecords(String patientId) async {
    try {
      state = state.copyWith(patientMedicalRecords: const AsyncValue.loading());
      final records = await _getMedicalRecordsUseCase.call(patientId: patientId);
      state = state.copyWith(patientMedicalRecords: AsyncValue.data(records));
    } catch (e, st) {
      state = state.copyWith(patientMedicalRecords: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchMedicalRecordDetails(String recordId) async {
    try {
      state = state.copyWith(selectedMedicalRecord: const AsyncValue.loading());
      final record = await _getMedicalRecordDetailsUseCase.call(recordId: recordId);
      state = state.copyWith(selectedMedicalRecord: AsyncValue.data(record));
    } catch (e, st) {
      state = state.copyWith(selectedMedicalRecord: AsyncValue.error(e, st));
    }
  }

  Future<void> createMedicalRecord({
    required String patientId,
    required String diagnosis,
    required String treatment,
    String? notes,
  }) async {
    try {
      await _createMedicalRecordUseCase.call(
        patientId: patientId,
        diagnosis: diagnosis,
        treatment: treatment,
        notes: notes,
      );
      // Fetch the updated list from backend
      await fetchPatientMedicalRecords(patientId);
    } catch (e, st) {
      // Handle error
    }
  }

  Future<void> updateMedicalRecord(
    String recordId, {
    required String patientId, // Added patientId here
    String? diagnosis,
    String? treatment,
    String? notes,
  }) async {
    try {
      await _updateMedicalRecordUseCase.call(
        recordId: recordId,
        diagnosis: diagnosis,
        treatment: treatment,
        notes: notes,
      );
      // Fetch the updated list from backend
      await fetchPatientMedicalRecords(patientId);
    } catch (e, st) {
      // Handle error
    }
  }

  Future<void> deleteMedicalRecord(String recordId, {required String patientId}) async { // Added patientId here
    try {
      await _deleteMedicalRecordUseCase.call(recordId: recordId);
      // Fetch the updated list from backend
      await fetchPatientMedicalRecords(patientId);
    } catch (e, st) {
      // Handle error
    }
  }

  Future<void> fetchPatientPrescriptions(String patientId) async {
    try {
      state = state.copyWith(patientPrescriptions: const AsyncValue.loading());
      final prescriptions = await _getPrescriptionsUseCase.call(patientId: patientId);
      state = state.copyWith(patientPrescriptions: AsyncValue.data(prescriptions));
    } catch (e, st) {
      state = state.copyWith(patientPrescriptions: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchPrescriptionDetails(String prescriptionId) async {
    try {
      state = state.copyWith(selectedPrescription: const AsyncValue.loading());
      final prescription = await _getPrescriptionDetailsUseCase.call(prescriptionId: prescriptionId);
      state = state.copyWith(selectedPrescription: AsyncValue.data(prescription));
    } catch (e, st) {
      state = state.copyWith(selectedPrescription: AsyncValue.error(e, st));
    }
  }

  Future<void> createPrescription({
    required String patientId,
    required List<Map<String, dynamic>> medications,
  }) async {
    try {
      final prescription = await _createPrescriptionUseCase.call(
        patientId: patientId,
        medications: medications,
      );
      final currentPrescriptions = state.patientPrescriptions?.value ?? [];
      state = state.copyWith(
        patientPrescriptions: AsyncValue.data([...currentPrescriptions, prescription]),
      );
    } catch (e, st) {
      // Handle error
    }
  }

  Future<void> updatePrescription(
    String prescriptionId, {
    required List<Map<String, dynamic>> medications,
  }) async {
    try {
      final updatedPrescription = await _updatePrescriptionUseCase.call(
        prescriptionId: prescriptionId,
        medications: medications,
      );
      final currentPrescriptions = state.patientPrescriptions?.value ?? [];
      final updatedPrescriptions = currentPrescriptions.map((prescription) {
        return prescription.id == prescriptionId ? updatedPrescription : prescription;
      }).toList();
      state = state.copyWith(
        patientPrescriptions: AsyncValue.data(updatedPrescriptions),
        selectedPrescription: AsyncValue.data(updatedPrescription),
      );
    } catch (e, st) {
      // Handle error
    }
  }

  Future<void> deletePrescription(String prescriptionId) async {
    try {
      await _deletePrescriptionUseCase.call(prescriptionId: prescriptionId);
      final currentPrescriptions = state.patientPrescriptions?.value ?? [];
      final updatedPrescriptions = currentPrescriptions.where((prescription) => prescription.id != prescriptionId).toList();
      state = state.copyWith(
        patientPrescriptions: AsyncValue.data(updatedPrescriptions),
        selectedPrescription: null,
      );
    } catch (e, st) {
      // Handle error
    }
  }

  Future<void> addMedication({
    required String name,
    required String dosage,
    required String frequency,
  }) async {
    final newMedication = Medication(
      name: name,
      dosage: dosage,
      frequency: frequency,
    );
    final currentPrescriptions = state.patientPrescriptions?.value ?? [];
    final updatedPrescriptions = currentPrescriptions.map((prescription) {
      if (prescription.id == state.selectedPrescription?.value?.id) {
        return PrescriptionModel(
          id: prescription.id,
          patientId: prescription.patientId,
          doctorId: prescription.doctorId,
          doctorName: prescription.doctorName,
          medications: [...prescription.medications, newMedication],
          createdAt: prescription.createdAt,
        );
      }
      return prescription;
    }).toList();
    state = state.copyWith(
      patientPrescriptions: AsyncValue.data(updatedPrescriptions),
    );
  }

  Future<void> removeMedication(int index) async {
    final currentPrescriptions = state.patientPrescriptions?.value ?? [];
    final updatedPrescriptions = currentPrescriptions.map((prescription) {
      if (prescription.id == state.selectedPrescription?.value?.id) {
        final updatedMedications = List<Medication>.from(prescription.medications)..removeAt(index);
        return PrescriptionModel(
          id: prescription.id,
          patientId: prescription.patientId,
          doctorId: prescription.doctorId,
          doctorName: prescription.doctorName,
          medications: updatedMedications,
          createdAt: prescription.createdAt,
        );
      }
      return prescription;
    }).toList();
    state = state.copyWith(
      patientPrescriptions: AsyncValue.data(updatedPrescriptions),
    );
  }
}

final doctorViewModelProvider = StateNotifierProvider<DoctorViewModel, DoctorState>((ref) {
  return DoctorViewModel(
    getAppointmentsUseCase: ref.watch(getDoctorAppointmentsUseCaseProvider),
    updateAppointmentStatusUseCase: ref.watch(updateAppointmentStatusUseCaseProvider),
    getPatientsUseCase: ref.watch(getDoctorPatientsUseCaseProvider),
    getPatientDetailsUseCase: ref.watch(getPatientDetailsForDoctorUseCaseProvider),
    getMedicalRecordsUseCase: ref.watch(getPatientMedicalRecordsForDoctorUseCaseProvider),
    getMedicalRecordDetailsUseCase: ref.watch(getMedicalRecordDetailsUseCaseProvider),
    createMedicalRecordUseCase: ref.watch(createMedicalRecordUseCaseProvider),
    updateMedicalRecordUseCase: ref.watch(updateMedicalRecordUseCaseProvider),
    deleteMedicalRecordUseCase: ref.watch(deleteMedicalRecordUseCaseProvider),
    getPrescriptionsUseCase: ref.watch(getPatientPrescriptionsForDoctorUseCaseProvider),
    getPrescriptionDetailsUseCase: ref.watch(getPrescriptionDetailsUseCaseProvider),
    createPrescriptionUseCase: ref.watch(createPrescriptionUseCaseProvider),
    updatePrescriptionUseCase: ref.watch(updatePrescriptionUseCaseProvider),
    deletePrescriptionUseCase: ref.watch(deletePrescriptionUseCaseProvider),
  );
});