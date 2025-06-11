import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

class GetPatientDoctorsUseCase {
  final PatientRepository _repository;

  GetPatientDoctorsUseCase(this._repository);

  Future<List<UserModel>> call() {
    return _repository.getPatientDoctors();
  }
}