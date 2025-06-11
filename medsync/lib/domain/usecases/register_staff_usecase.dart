import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/admin_repository.dart';

class RegisterStaffUseCase {
  final AdminRepository repository;

  RegisterStaffUseCase(this.repository);

  Future<UserModel> call(
      String name, String email, String password, String role,
      {Map<String, dynamic>? otherData}) {
    return repository.registerStaff(name, email, password, role,
        otherData: otherData);
  }
}