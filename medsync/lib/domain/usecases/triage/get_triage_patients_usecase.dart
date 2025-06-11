import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/triage_repository.dart';

class GetTriagePatientsUseCase {
  final TriageRepository repository;
  GetTriagePatientsUseCase(this.repository);

  Future<List<UserModel>> call({String? department}) {
    return repository.getTriagePatients(department: department);
  }
} 