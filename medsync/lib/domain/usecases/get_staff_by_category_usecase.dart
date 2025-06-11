import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/admin_repository.dart';

class GetStaffByCategoryUseCase {
  final AdminRepository repository;

  GetStaffByCategoryUseCase(this.repository);

  Future<List<UserModel>> call(String role, {String? search}) {
    return repository.getStaffByCategory(role, search: search);
  }
}