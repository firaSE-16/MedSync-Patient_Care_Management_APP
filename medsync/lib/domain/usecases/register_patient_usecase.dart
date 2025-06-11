import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/domain/repositories/user_repository.dart';

class RegisterPatientUseCase {
  final UserRepository repository;

  RegisterPatientUseCase(this.repository);

  Future<UserModel> execute(Map<String, dynamic> data) async {
    return await repository.registerPatient(data);
  }
}