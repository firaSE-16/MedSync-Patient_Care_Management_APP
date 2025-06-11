import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/usecases/get_staff_by_category_usecase.dart';
import 'package:medsync/domain/usecases/register_staff_usecase.dart';
import 'package:medsync/core/providers.dart'; // <--- ADD THIS IMPORT


class AdminStaffState {
  final AsyncValue<List<UserModel>> staffList;
  final AsyncValue<UserModel?> registeredStaff;

  AdminStaffState({
    required this.staffList,
    required this.registeredStaff,
  });

  AdminStaffState copyWith({
    AsyncValue<List<UserModel>>? staffList,
    AsyncValue<UserModel?>? registeredStaff,
  }) {
    return AdminStaffState(
      staffList: staffList ?? this.staffList,
      registeredStaff: registeredStaff ?? this.registeredStaff,
    );
  }
}

final adminStaffViewModelProvider =
    StateNotifierProvider<AdminStaffViewModel, AdminStaffState>(
  (ref) {
    final getStaffByCategoryUseCase =
        ref.read(getStaffByCategoryUseCaseProvider);
    final registerStaffUseCase = ref.read(registerStaffUseCaseProvider);
    return AdminStaffViewModel(
        getStaffByCategoryUseCase, registerStaffUseCase);
  },
);

class AdminStaffViewModel extends StateNotifier<AdminStaffState> {
  final GetStaffByCategoryUseCase _getStaffByCategoryUseCase;
  final RegisterStaffUseCase _registerStaffUseCase;

  AdminStaffViewModel(this._getStaffByCategoryUseCase, this._registerStaffUseCase)
      : super(AdminStaffState(
          staffList: const AsyncValue.loading(),
          registeredStaff: const AsyncValue.data(null),
        ));

  Future<void> fetchStaffByCategory(String role) async {
    state = state.copyWith(staffList: const AsyncValue.loading());
    try {
      final staff = await _getStaffByCategoryUseCase.call(role);
      state = state.copyWith(staffList: AsyncValue.data(staff));
    } catch (e, st) {
      state = state.copyWith(staffList: AsyncValue.error(e, st));
    }
  }

  Future<void> registerStaff(
      String name, String email, String password, String role,
      {Map<String, dynamic>? otherData}) async {
    state = state.copyWith(registeredStaff: const AsyncValue.loading());
    try {
      final newStaff = await _registerStaffUseCase.call(
          name, email, password, role,
          otherData: otherData);
      state = state.copyWith(registeredStaff: AsyncValue.data(newStaff));
      // Optionally re-fetch staff list if the new staff belongs to the current category
      if (role == 'doctor' || role == 'triage' || role == 'admin') {
        fetchStaffByCategory(role);
      }
    } catch (e, st) {
      state = state.copyWith(registeredStaff: AsyncValue.error(e, st));
    }
  }
}