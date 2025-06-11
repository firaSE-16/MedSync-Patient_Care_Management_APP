import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:medsync/domain/usecases/get_appointments_by_status_usecase.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/usecases/get_patients_usecase.dart';
import 'package:medsync/domain/usecases/get_staff_by_category_usecase.dart';
import 'package:medsync/core/providers.dart'; // <--- ADD THIS IMPORT

class AdminDashboardState {
  final AsyncValue<Map<String, dynamic>> dashboardStats;
  final AsyncValue<List<AppointmentModel>> appointments;
  final AsyncValue<List<UserModel>> patients;
  final AsyncValue<List<UserModel>> doctors;
  final AsyncValue<List<UserModel>> triageStaff;


  AdminDashboardState({
    required this.dashboardStats,
    required this.appointments,
    required this.patients,
    required this.doctors,
    required this.triageStaff,
  });

  AdminDashboardState copyWith({
    AsyncValue<Map<String, dynamic>>? dashboardStats,
    AsyncValue<List<AppointmentModel>>? appointments,
    AsyncValue<List<UserModel>>? patients,
    AsyncValue<List<UserModel>>? doctors,
    AsyncValue<List<UserModel>>? triageStaff,
  }) {
    return AdminDashboardState(
      dashboardStats: dashboardStats ?? this.dashboardStats,
      appointments: appointments ?? this.appointments,
      patients: patients ?? this.patients,
      doctors: doctors ?? this.doctors,
      triageStaff: triageStaff ?? this.triageStaff,
    );
  }
}

final adminDashboardViewModelProvider =
    StateNotifierProvider<AdminDashboardViewModel, AdminDashboardState>(
  (ref) {
    final getDashboardStatsUseCase = ref.read(getDashboardStatsUseCaseProvider);
    final getAppointmentsByStatusUseCase =
        ref.read(getAppointmentsByStatusUseCaseProvider);
    final getPatientsUseCase = ref.read(getPatientsUseCaseProvider);
    final getStaffByCategoryUseCase = ref.read(getStaffByCategoryUseCaseProvider);

    return AdminDashboardViewModel(
      getDashboardStatsUseCase,
      getAppointmentsByStatusUseCase,
      getPatientsUseCase,
      getStaffByCategoryUseCase,
    );
  },
);

class AdminDashboardViewModel extends StateNotifier<AdminDashboardState> {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;
  final GetAppointmentsByStatusUseCase _getAppointmentsByStatusUseCase;
  final GetPatientsUseCase _getPatientsUseCase;
  final GetStaffByCategoryUseCase _getStaffByCategoryUseCase;

  AdminDashboardViewModel(
    this._getDashboardStatsUseCase,
    this._getAppointmentsByStatusUseCase,
    this._getPatientsUseCase,
    this._getStaffByCategoryUseCase,
  ) : super(AdminDashboardState(
          dashboardStats: const AsyncValue.loading(),
          appointments: const AsyncValue.loading(),
          patients: const AsyncValue.loading(),
          doctors: const AsyncValue.loading(),
          triageStaff: const AsyncValue.loading(),
        )) {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    state = state.copyWith(
      dashboardStats: const AsyncValue.loading(),
      appointments: const AsyncValue.loading(),
      patients: const AsyncValue.loading(),
      doctors: const AsyncValue.loading(),
      triageStaff: const AsyncValue.loading(),
    );
    try {
      final stats = await _getDashboardStatsUseCase.call();
      state = state.copyWith(dashboardStats: AsyncValue.data(stats));

      final appointments =
          await _getAppointmentsByStatusUseCase.call(status: 'scheduled');
      state = state.copyWith(appointments: AsyncValue.data(appointments));

      final patients = await _getPatientsUseCase.call();
      state = state.copyWith(patients: AsyncValue.data(patients));

      final doctors = await _getStaffByCategoryUseCase.call('doctor');
      state = state.copyWith(doctors: AsyncValue.data(doctors));

      final triageStaff = await _getStaffByCategoryUseCase.call('triage');
      state = state.copyWith(triageStaff: AsyncValue.data(triageStaff));

    } catch (e, st) {
      state = state.copyWith(
        dashboardStats: AsyncValue.error(e, st),
        appointments: AsyncValue.error(e, st),
        patients: AsyncValue.error(e, st),
        doctors: AsyncValue.error(e, st),
        triageStaff: AsyncValue.error(e, st),
      );
    }
  }

  Future<void> fetchAppointmentsByStatus(String status) async {
    state = state.copyWith(appointments: const AsyncValue.loading());
    try {
      final appointments =
          await _getAppointmentsByStatusUseCase.call(status: status);
      state = state.copyWith(appointments: AsyncValue.data(appointments));
    } catch (e, st) {
      state = state.copyWith(appointments: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchPatients({String? search}) async {
    state = state.copyWith(patients: const AsyncValue.loading());
    try {
      final patients = await _getPatientsUseCase.call(search: search);
      state = state.copyWith(patients: AsyncValue.data(patients));
    } catch (e, st) {
      state = state.copyWith(patients: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchStaffByCategory(String role) async {
    if (role == 'doctor') {
      state = state.copyWith(doctors: const AsyncValue.loading());
    } else if (role == 'triage') {
      state = state.copyWith(triageStaff: const AsyncValue.loading());
    }
    try {
      final staff = await _getStaffByCategoryUseCase.call(role);
      if (role == 'doctor') {
        state = state.copyWith(doctors: AsyncValue.data(staff));
      } else if (role == 'triage') {
        state = state.copyWith(triageStaff: AsyncValue.data(staff));
      }
    } catch (e, st) {
      if (role == 'doctor') {
        state = state.copyWith(doctors: AsyncValue.error(e, st));
      } else if (role == 'triage') {
        state = state.copyWith(triageStaff: AsyncValue.error(e, st));
      }
    }
  }
}