import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/admin_repository.dart';

class GetPatientsUseCase {
  final AdminRepository repository;

  GetPatientsUseCase(this.repository);

  Future<List<UserModel>> call(
      {int page = 1, int limit = 10, String? search}) {
    return repository.getPatients(page: page, limit: limit, search: search);
  }
}