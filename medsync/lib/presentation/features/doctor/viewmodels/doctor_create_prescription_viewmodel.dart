import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/domain/usecases/doctor/create_prescription_usecase.dart';

class DoctorCreatePrescriptionViewModel extends StateNotifier<AsyncValue<void>> {
  final CreatePrescriptionUseCase _createPrescriptionUseCase;

  DoctorCreatePrescriptionViewModel(this._createPrescriptionUseCase) : super(const AsyncValue.data(null));

  Future<void> createPrescription(Map<String, dynamic> prescriptionData) async {
    try {
      state = const AsyncValue.loading();
      await _createPrescriptionUseCase.call(
        patientId: prescriptionData['patientId'],
        medications: prescriptionData['medications'],
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 