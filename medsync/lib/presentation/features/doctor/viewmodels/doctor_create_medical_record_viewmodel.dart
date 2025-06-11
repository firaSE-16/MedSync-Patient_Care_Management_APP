import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/domain/usecases/doctor/create_medical_record_usecase.dart';

class DoctorCreateMedicalRecordViewModel extends StateNotifier<AsyncValue<void>> {
  final CreateMedicalRecordUseCase _createMedicalRecordUseCase;

  DoctorCreateMedicalRecordViewModel(this._createMedicalRecordUseCase) : super(const AsyncValue.data(null));

  Future<void> createMedicalRecord(Map<String, dynamic> recordData) async {
    try {
      state = const AsyncValue.loading();
      await _createMedicalRecordUseCase.call(
        patientId: recordData['patientId'],
        diagnosis: recordData['diagnosis'],
        treatment: recordData['treatment'],
        notes: recordData['notes'],
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 