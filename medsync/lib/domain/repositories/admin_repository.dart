import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/data/models/user_model.dart';

abstract class AdminRepository {
  Future<UserModel> registerStaff(
      String name, String email, String password, String role,
      {Map<String, dynamic>? otherData});
  Future<List<UserModel>> getStaffByCategory(String role, {String? search});
  Future<Map<String, dynamic>> getDashboardStats();
  Future<List<AppointmentModel>> getAppointmentsByStatus(
      {String? status, int page, int limit});
  Future<List<UserModel>> getPatients(
      {int page, int limit, String? search});
}