import 'package:medsync/domain/repositories/doctor_repository.dart';

class GetPatientDetailsForDoctorUseCase {
  final DoctorRepository _repository;

  GetPatientDetailsForDoctorUseCase(this._repository);

  Future<Map<String, dynamic>> call({required String patientId}) {
    return _repository.getPatientDetailsForDoctor(patientId);
  }
} 