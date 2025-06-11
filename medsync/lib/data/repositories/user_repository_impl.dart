import 'package:medsync/data/datasources/remote/network/api_service.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<UserModel> registerPatient(Map<String, dynamic> data) async {
    return await apiService.registerPatient(data);
  }

  @override
  Future<UserModel> login(Map<String, dynamic> data) async {
    return await apiService.login(data);
  }
}