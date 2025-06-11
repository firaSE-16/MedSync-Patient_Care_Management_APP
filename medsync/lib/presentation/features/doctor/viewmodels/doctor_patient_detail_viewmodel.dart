import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/data/models/user_model.dart';
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

class DoctorPatientDetailViewModel extends StateNotifier<AsyncValue<void>> {
  final String patientId;
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

  DoctorPatientDetailViewModel(
    this.patientId,
    this._getPatientDetailsUseCase,
    this._getMedicalRecordsUseCase,
    this._getMedicalRecordDetailsUseCase,
    this._createMedicalRecordUseCase,
    this._updateMedicalRecordUseCase,
    this._deleteMedicalRecordUseCase,
    this._getPrescriptionsUseCase,
    this._getPrescriptionDetailsUseCase,
    this._createPrescriptionUseCase,
    this._updatePrescriptionUseCase,
    this._deletePrescriptionUseCase,
  ) : super(const AsyncValue.loading()) {
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    try {
      state = const AsyncValue.loading();
      final patientDetails = await _getPatientDetailsUseCase.call(patientId: patientId);
      if (kDebugMode) {
        print('Patient Details: $patientDetails');
      }
      state = AsyncValue.data(patientDetails);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchMedicalRecords() async {
    try {
      state = const AsyncValue.loading();
      final records = await _getMedicalRecordsUseCase.call(patientId: patientId);
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchPrescriptions() async {
    try {
      state = const AsyncValue.loading();
      final prescriptions = await _getPrescriptionsUseCase.call(patientId: patientId);
      state = AsyncValue.data(prescriptions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createMedicalRecord(Map<String, dynamic> recordData) async {
    try {
      state = const AsyncValue.loading();
      await _createMedicalRecordUseCase.call(
        patientId: recordData['patientId'],
        diagnosis: recordData['diagnosis'],
        treatment: recordData['treatment'],
        notes: recordData['notes'],
      );
      await fetchMedicalRecords();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMedicalRecord(String recordId, Map<String, dynamic> recordData) async {
    try {
      state = const AsyncValue.loading();
      await _updateMedicalRecordUseCase.call(
        recordId: recordId,
        diagnosis: recordData['diagnosis'],
        treatment: recordData['treatment'],
        notes: recordData['notes'],
      );
      await fetchMedicalRecords();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMedicalRecord(String recordId) async {
    try {
      state = const AsyncValue.loading();
      await _deleteMedicalRecordUseCase.call(recordId:recordId);
      await fetchMedicalRecords();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createPrescription(Map<String, dynamic> prescriptionData) async {
    try {
      state = const AsyncValue.loading();
      await _createPrescriptionUseCase.call(
        patientId: prescriptionData['patientId'],
        medications: prescriptionData['medications'],
      );
      await fetchPrescriptions();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePrescription(String prescriptionId, Map<String, dynamic> prescriptionData) async {
    try {
      state = const AsyncValue.loading();
      await _updatePrescriptionUseCase.call(
        prescriptionId: prescriptionId,
        medications: prescriptionData['medications'],
      );
      await fetchPrescriptions();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePrescription(String prescriptionId) async {
    try {
      state = const AsyncValue.loading();
      await _deletePrescriptionUseCase.call(prescriptionId: prescriptionId);
      await fetchPrescriptions();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final doctorPatientDetailViewModelProvider = StateNotifierProvider.family<DoctorPatientDetailViewModel, AsyncValue<void>, String>((ref, patientId) {
  final getPatientDetailsUseCase = ref.watch(getPatientDetailsForDoctorUseCaseProvider);
  final getMedicalRecordsUseCase = ref.watch(getPatientMedicalRecordsForDoctorUseCaseProvider);
  final getMedicalRecordDetailsUseCase = ref.watch(getMedicalRecordDetailsUseCaseProvider);
  final createMedicalRecordUseCase = ref.watch(createMedicalRecordUseCaseProvider);
  final updateMedicalRecordUseCase = ref.watch(updateMedicalRecordUseCaseProvider);
  final deleteMedicalRecordUseCase = ref.watch(deleteMedicalRecordUseCaseProvider);
  final getPrescriptionsUseCase = ref.watch(getPatientPrescriptionsForDoctorUseCaseProvider);
  final getPrescriptionDetailsUseCase = ref.watch(getPrescriptionDetailsUseCaseProvider);
  final createPrescriptionUseCase = ref.watch(createPrescriptionUseCaseProvider);
  final updatePrescriptionUseCase = ref.watch(updatePrescriptionUseCaseProvider);
  final deletePrescriptionUseCase = ref.watch(deletePrescriptionUseCaseProvider);

  return DoctorPatientDetailViewModel(
    patientId,
    getPatientDetailsUseCase,
    getMedicalRecordsUseCase,
    getMedicalRecordDetailsUseCase,
    createMedicalRecordUseCase,
    updateMedicalRecordUseCase,
    deleteMedicalRecordUseCase,
    getPrescriptionsUseCase,
    getPrescriptionDetailsUseCase,
    createPrescriptionUseCase,
    updatePrescriptionUseCase,
    deletePrescriptionUseCase,
  );
}); 