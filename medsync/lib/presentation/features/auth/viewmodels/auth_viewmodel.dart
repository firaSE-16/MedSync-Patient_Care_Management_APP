import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/core/services/shared_preferences_service.dart';
import 'package:medsync/core/utils/custom_exceptions.dart';
import 'package:medsync/data/datasources/remote/network/api_service.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/repositories/user_repository_impl.dart';
import 'package:medsync/domain/repositories/user_repository.dart';
import 'package:medsync/domain/usecases/login_usecase.dart';
import 'package:medsync/domain/usecases/register_patient_usecase.dart';
import 'package:medsync/domain/usecases/register_staff_usecase.dart';
import 'package:medsync/core/constants/app_constants.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<UserModel?>>((ref) {
  final registerUseCase = ref.watch(registerPatientUseCaseProvider);
  final loginUseCase = ref.watch(loginUseCaseProvider);
  
  return AuthViewModel(registerUseCase, loginUseCase);
});

class AuthViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final RegisterPatientUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
 

  AuthViewModel(
    this._registerUseCase,
    this._loginUseCase,

  ) : super(const AsyncValue.data(null));

  Future<void> registerPatient({
    required String name,
    required String email,
    required String password,
    required String dateOfBirth,
    required String gender,
    required String bloodGroup,
    String? emergencyContactName,
    String? emergencyContactNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _registerUseCase.execute({
        'name': name,
        'email': email,
        'password': password,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'emergencyContactName': emergencyContactName,
        'emergencyContactNumber': emergencyContactNumber,
      });
      if (user == null) {
        throw ApiException('Registration failed: No user data received');
      }
      await _saveUserData(user);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      final error = e is ApiException ? e : ApiException(e.toString());
      state = AsyncValue.error(error, stackTrace);
    }
  }

  
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _loginUseCase.execute({
        'email': email,
        'password': password,
      });
      if (user == null) {
        throw ApiException('Login failed: No user data received');
      }
      await _saveUserData(user);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      final error = e is ApiException ? e : ApiException(e.toString());
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _saveUserData(UserModel user) async {
    if (user.token == null) {
      throw ApiException('Authentication failed: No token received');
    }
    if (user.role == null) {
      throw ApiException('Authentication failed: No role received');
    }
    if (user.id == null) {
      throw ApiException('Authentication failed: No user ID received');
    }
    
    await SharedPreferencesService.setString(AppConstants.tokenKey, user.token!);
    await SharedPreferencesService.setString(AppConstants.roleKey, user.role!);
    await SharedPreferencesService.setString(AppConstants.userIdKey, user.id!);
  }

  Future<void> logout() async {
    await SharedPreferencesService.clear();
    state = const AsyncValue.data(null);
  }
}

final registerPatientUseCaseProvider = Provider<RegisterPatientUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return RegisterPatientUseCase(repository);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return LoginUseCase(repository);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserRepositoryImpl(apiService);
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});