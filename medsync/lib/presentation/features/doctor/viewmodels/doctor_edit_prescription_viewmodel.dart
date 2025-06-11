import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/domain/usecases/doctor/update_prescription_usecase.dart';
import 'package:medsync/domain/usecases/doctor/get_prescription_details_usecase.dart';

class DoctorEditPrescriptionViewModel extends StateNotifier<AsyncValue<void>> {
  final String prescriptionId;
  final UpdatePrescriptionUseCase _updatePrescriptionUseCase;
  final GetPrescriptionDetailsUseCase _getPrescriptionDetailsUseCase;

  DoctorEditPrescriptionViewModel(this.prescriptionId, this._updatePrescriptionUseCase, this._getPrescriptionDetailsUseCase) : super(const AsyncValue.data(null));

  Future<void> updatePrescription(Map<String, dynamic> prescriptionData) async {
    try {
      state = const AsyncValue.loading();
      await _updatePrescriptionUseCase.call(
        prescriptionId: prescriptionId,
        medications: prescriptionData['medications'],
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchPrescriptionDetails() async {
    try {
      state = const AsyncValue.loading();
      final details = await _getPrescriptionDetailsUseCase.call(prescriptionId: prescriptionId);
      state = AsyncValue.data(details);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 