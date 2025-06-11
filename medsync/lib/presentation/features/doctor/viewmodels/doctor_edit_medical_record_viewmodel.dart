import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/domain/usecases/doctor/update_medical_record_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_medical_record_details_usecase.dart';

class DoctorEditMedicalRecordViewModel extends StateNotifier<AsyncValue<void>> {
  final String recordId;
  final UpdateMedicalRecordUseCase _updateMedicalRecordUseCase;
  final GetMedicalRecordDetailsUseCase _getMedicalRecordDetailsUseCase;

  DoctorEditMedicalRecordViewModel(this.recordId, this._updateMedicalRecordUseCase, this._getMedicalRecordDetailsUseCase) : super(const AsyncValue.data(null));

  Future<void> updateMedicalRecord(Map<String, dynamic> recordData) async {
    try {
      state = const AsyncValue.loading();
      await _updateMedicalRecordUseCase.call(
        recordId: recordId,
        diagnosis: recordData['diagnosis'],
        treatment: recordData['treatment'],
        notes: recordData['notes'],
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchMedicalRecordDetails() async {
    try {
      state = const AsyncValue.loading();
      final details = await _getMedicalRecordDetailsUseCase.call(recordId: recordId);
      state = AsyncValue.data(details);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 