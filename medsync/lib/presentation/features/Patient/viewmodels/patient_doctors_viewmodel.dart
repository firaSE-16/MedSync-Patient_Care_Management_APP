import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/usecases/patient/get_patient_doctors_usecase.dart';
import 'package:medsync/core/providers.dart';

class PatientDoctorsState {
  final AsyncValue<List<UserModel>> doctors;

  PatientDoctorsState({
    required this.doctors,
  });

  PatientDoctorsState copyWith({
    AsyncValue<List<UserModel>>? doctors,
  }) {
    return PatientDoctorsState(
      doctors: doctors ?? this.doctors,
    );
  }
}

final patientDoctorsViewModelProvider =
    StateNotifierProvider<PatientDoctorsViewModel, PatientDoctorsState>(
  (ref) {
    final getDoctorsUseCase = ref.read(getPatientDoctorsUseCaseProvider);
    return PatientDoctorsViewModel(getDoctorsUseCase);
  },
);

class PatientDoctorsViewModel extends StateNotifier<PatientDoctorsState> {
  final GetPatientDoctorsUseCase _getDoctorsUseCase;

  PatientDoctorsViewModel(this._getDoctorsUseCase)
      : super(PatientDoctorsState(doctors: const AsyncValue.loading())) {
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    state = state.copyWith(doctors: const AsyncValue.loading());
    try {
      final data = await _getDoctorsUseCase.call();
      state = state.copyWith(doctors: AsyncValue.data(data));
    } catch (e, st) {
      state = state.copyWith(doctors: AsyncValue.error(e, st));
    }
  }
}