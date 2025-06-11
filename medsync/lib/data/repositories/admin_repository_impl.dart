import 'package:medsync/data/datasources/remote/network/api_service.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final ApiService apiService;

  AdminRepositoryImpl(this.apiService);

  @override
  Future<UserModel> registerStaff(
      String name, String email, String password, String role,
      {Map<String, dynamic>? otherData}) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      ...?otherData,
    };
    return await apiService.registerStaff(data);
  }

  @override
  Future<List<UserModel>> getStaffByCategory(String role, {String? search}) async {
    return await apiService.getStaffByCategory(role, search: search);
  }

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    return await apiService.getDashboardStats();
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByStatus(
      {String? status, int page = 1, int limit = 10}) async {
    return await apiService.getAppointmentsByStatus(
        status: status, page: page, limit: limit);
  }

  @override
  Future<List<UserModel>> getPatients(
      {int page = 1, int limit = 10, String? search}) async {
    return await apiService.getPatients(page: page, limit: limit, search: search);
  }
}