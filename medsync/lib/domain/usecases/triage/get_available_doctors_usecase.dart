import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/triage_repository.dart';

class GetAvailableDoctorsUseCase {
  final TriageRepository repository;
  GetAvailableDoctorsUseCase(this.repository);

  Future<List<UserModel>> call({String? department}) {
    return repository.getAvailableDoctors(department: department);
  }
} 