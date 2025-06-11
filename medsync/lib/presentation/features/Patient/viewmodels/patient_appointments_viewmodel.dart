import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/domain/usecases/patient/get_patient_appointments_usecase.dart';
import 'package:medsync/core/providers.dart';

class PatientAppointmentsState {
  final AsyncValue<List<AppointmentModel>> appointments;

  PatientAppointmentsState({
    required this.appointments,
  });

  PatientAppointmentsState copyWith({
    AsyncValue<List<AppointmentModel>>? appointments,
  }) {
    return PatientAppointmentsState(
      appointments: appointments ?? this.appointments,
    );
  }
}

final patientAppointmentsViewModelProvider =
    StateNotifierProvider<PatientAppointmentsViewModel, PatientAppointmentsState>(
  (ref) {
    final getAppointmentsUseCase = ref.read(getPatientAppointmentsUseCaseProvider);
    return PatientAppointmentsViewModel(getAppointmentsUseCase);
  },
);

class PatientAppointmentsViewModel extends StateNotifier<PatientAppointmentsState> {
  final GetPatientAppointmentsUseCase _getAppointmentsUseCase;

  PatientAppointmentsViewModel(this._getAppointmentsUseCase)
      : super(PatientAppointmentsState(appointments: const AsyncValue.loading())) {
    fetchAppointments(); // Fetch all initially
  }

  Future<void> fetchAppointments({String? status, bool? upcoming}) async {
    state = state.copyWith(appointments: const AsyncValue.loading());
    try {
      final data = await _getAppointmentsUseCase.call(status: status, upcoming: upcoming);
      state = state.copyWith(appointments: AsyncValue.data(data));
    } catch (e, st) {
      state = state.copyWith(appointments: AsyncValue.error(e, st));
    }
  }
}