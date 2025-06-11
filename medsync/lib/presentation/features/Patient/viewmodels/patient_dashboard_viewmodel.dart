import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/dashboard_stats_model.dart';
import 'package:medsync/domain/usecases/patient/get_patient_dashboard_usecase.dart';
import 'package:medsync/core/providers.dart'; // Import your providers
import 'package:medsync/domain/repositories/patient_repository.dart'; // Import PatientRepository
import 'package:medsync/data/models/appointment_model.dart'; // Import AppointmentModel

class PatientDashboardState {
  final AsyncValue<PatientDashboardData> dashboardData;

  PatientDashboardState({
    required this.dashboardData,
  });

  PatientDashboardState copyWith({
    AsyncValue<PatientDashboardData>? dashboardData,
  }) {
    return PatientDashboardState(
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }
}

final patientDashboardViewModelProvider =
    StateNotifierProvider<PatientDashboardViewModel, PatientDashboardState>(
  (ref) {
    final getDashboardUseCase = ref.read(getPatientDashboardUseCaseProvider);
    final patientRepository = ref.read(patientRepositoryProvider);
    return PatientDashboardViewModel(getDashboardUseCase, patientRepository);
  },
);

class PatientDashboardViewModel extends StateNotifier<PatientDashboardState> {
  final GetPatientDashboardUseCase _getDashboardUseCase;
  final PatientRepository _patientRepository;

  PatientDashboardViewModel(this._getDashboardUseCase, this._patientRepository)
      : super(PatientDashboardState(dashboardData: const AsyncValue.loading())) {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    state = state.copyWith(dashboardData: const AsyncValue.loading());
    try {
      final dashboardData = await _getDashboardUseCase.call();

      // Fetch upcoming appointments separately with specific parameters
      final upcomingAppointments = await _patientRepository.getPatientAppointments(
        status: 'scheduled',
        upcoming: true,
      );
      print('Fetched upcoming appointments: ${upcomingAppointments.length}');
      if (upcomingAppointments.isNotEmpty) {
        print('First upcoming appointment: ${upcomingAppointments.first.toJson()}');
      }

      // Combine the fetched data into a new PatientDashboardData instance
      final combinedData = PatientDashboardData(
        upcomingAppointments: upcomingAppointments, // Use the separately fetched appointments
        recentPrescriptions: dashboardData.recentPrescriptions,
        pendingBookings: dashboardData.pendingBookings,
        medicalHistory: dashboardData.medicalHistory,
        allergies: dashboardData.allergies,
        conditions: dashboardData.conditions,
      );

      state = state.copyWith(dashboardData: AsyncValue.data(combinedData));
    } catch (e, st) {
      state = state.copyWith(dashboardData: AsyncValue.error(e, st));
    }
  }

  // You might add methods to refresh individual sections if needed,
  // but for a dashboard, fetching all at once is common.
}