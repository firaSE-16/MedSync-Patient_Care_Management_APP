import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/domain/usecases/patient/get_patient_prescriptions_usecase.dart';
import 'package:medsync/core/providers.dart';

class PatientPrescriptionsState {
  final AsyncValue<List<PrescriptionModel>> prescriptions;

  PatientPrescriptionsState({
    required this.prescriptions,
  });

  PatientPrescriptionsState copyWith({
    AsyncValue<List<PrescriptionModel>>? prescriptions,
  }) {
    return PatientPrescriptionsState(
      prescriptions: prescriptions ?? this.prescriptions,
    );
  }
}

final patientPrescriptionsViewModelProvider =
    StateNotifierProvider<PatientPrescriptionsViewModel, PatientPrescriptionsState>(
  (ref) {
    final getPrescriptionsUseCase = ref.read(getPatientPrescriptionsUseCaseProvider);
    return PatientPrescriptionsViewModel(getPrescriptionsUseCase);
  },
);

class PatientPrescriptionsViewModel extends StateNotifier<PatientPrescriptionsState> {
  final GetPatientPrescriptionsUseCase _getPrescriptionsUseCase;

  PatientPrescriptionsViewModel(this._getPrescriptionsUseCase)
      : super(PatientPrescriptionsState(prescriptions: const AsyncValue.loading())) {
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    state = state.copyWith(prescriptions: const AsyncValue.loading());
    try {
      final data = await _getPrescriptionsUseCase.call();
      state = state.copyWith(prescriptions: AsyncValue.data(data));
    } catch (e, st) {
      state = state.copyWith(prescriptions: AsyncValue.error(e, st));
    }
  }
}