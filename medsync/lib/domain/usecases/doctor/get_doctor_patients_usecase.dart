import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class GetDoctorPatientsUseCase {
  final DoctorRepository _repository;

  GetDoctorPatientsUseCase(this._repository);

  Future<List<UserModel>> call() {
    return _repository.getDoctorPatients();
  }
} 