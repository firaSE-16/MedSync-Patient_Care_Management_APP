import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/data/models/prescription_model.dart';

class DoctorState {
  final AsyncValue<List<AppointmentModel>> appointments;
  final AsyncValue<List<UserModel>> patients;
  final AsyncValue<Map<String, dynamic>>? selectedPatient;
  final AsyncValue<List<MedicalHistoryModel>>? patientMedicalRecords;
  final AsyncValue<List<PrescriptionModel>>? patientPrescriptions;
  final AsyncValue<MedicalHistoryModel>? selectedMedicalRecord;
  final AsyncValue<PrescriptionModel>? selectedPrescription;

  DoctorState({
    required this.appointments,
    required this.patients,
    this.selectedPatient,
    this.patientMedicalRecords,
    this.patientPrescriptions,
    this.selectedMedicalRecord,
    this.selectedPrescription,
  });

  DoctorState copyWith({
    AsyncValue<List<AppointmentModel>>? appointments,
    AsyncValue<List<UserModel>>? patients,
    AsyncValue<Map<String, dynamic>>? selectedPatient,
    AsyncValue<List<MedicalHistoryModel>>? patientMedicalRecords,
    AsyncValue<List<PrescriptionModel>>? patientPrescriptions,
    AsyncValue<MedicalHistoryModel>? selectedMedicalRecord,
    AsyncValue<PrescriptionModel>? selectedPrescription,
  }) {
    return DoctorState(
      appointments: appointments ?? this.appointments,
      patients: patients ?? this.patients,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      patientMedicalRecords: patientMedicalRecords ?? this.patientMedicalRecords,
      patientPrescriptions: patientPrescriptions ?? this.patientPrescriptions,
      selectedMedicalRecord: selectedMedicalRecord ?? this.selectedMedicalRecord,
      selectedPrescription: selectedPrescription ?? this.selectedPrescription,
    );
  }
} 