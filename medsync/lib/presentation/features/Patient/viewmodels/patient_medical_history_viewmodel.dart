import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

final patientMedicalHistoryProvider = FutureProvider<List<MedicalHistoryModel>>((ref) async {
  final repository = ref.watch(patientRepositoryProvider);
  return await repository.getPatientMedicalHistory();
});

final patientMedicalRecordsProvider = FutureProvider<List<MedicalHistoryModel>>((ref) async {
  final repository = ref.watch(patientRepositoryProvider);
  return await repository.getPatientMedicalRecords();
});
