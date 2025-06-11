import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/usecases/doctor/get_doctor_patients_usecase.dart';

class DoctorPatientsViewModel extends StateNotifier<AsyncValue<List<UserModel>>> {
  final GetDoctorPatientsUseCase _getDoctorPatientsUseCase;

  DoctorPatientsViewModel(this._getDoctorPatientsUseCase) : super(const AsyncValue.loading()) {
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      state = const AsyncValue.loading();
      final patients = await _getDoctorPatientsUseCase.call();
      state = AsyncValue.data(patients);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final doctorPatientsViewModelProvider = StateNotifierProvider.autoDispose<DoctorPatientsViewModel, AsyncValue<List<UserModel>>>((ref) {
  final getPatientsUseCase = ref.watch(getDoctorPatientsUseCaseProvider);
  return DoctorPatientsViewModel(getPatientsUseCase);
}); 