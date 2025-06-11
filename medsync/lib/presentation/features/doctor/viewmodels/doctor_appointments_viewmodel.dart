import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/domain/usecases/doctor/get_doctor_appointments_usecase.dart';
import 'package:medsync/domain/usecases/doctor/update_appointment_status_usecase.dart';

class DoctorAppointmentsViewModel extends StateNotifier<AsyncValue<List<AppointmentModel>>> {
  final GetDoctorAppointmentsUseCase _getDoctorAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase _updateAppointmentStatusUseCase;

  DoctorAppointmentsViewModel(this._getDoctorAppointmentsUseCase, this._updateAppointmentStatusUseCase) : super(const AsyncValue.loading()) {
    fetchAppointments();
  }

  Future<void> fetchAppointments({String? status, String? date}) async {
    try {
      state = const AsyncValue.loading();
      final appointments = await _getDoctorAppointmentsUseCase.call(status: status, date: date);
      state = AsyncValue.data(appointments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      state = const AsyncValue.loading();
      await _updateAppointmentStatusUseCase.call(appointmentId: appointmentId, status: status);
      await fetchAppointments();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final doctorAppointmentsViewModelProvider = StateNotifierProvider<DoctorAppointmentsViewModel, AsyncValue<List<AppointmentModel>>>((ref) {
  final getAppointmentsUseCase = ref.watch(getDoctorAppointmentsUseCaseProvider);
  final updateAppointmentStatusUseCase = ref.watch(updateAppointmentStatusUseCaseProvider);
  return DoctorAppointmentsViewModel(getAppointmentsUseCase, updateAppointmentStatusUseCase);
}); 