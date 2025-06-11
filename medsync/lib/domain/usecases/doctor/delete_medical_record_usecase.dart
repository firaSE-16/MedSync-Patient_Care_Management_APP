import 'package:medsync/domain/repositories/doctor_repository.dart';

class DeleteMedicalRecordUseCase {
  final DoctorRepository _repository;

  DeleteMedicalRecordUseCase(this._repository);

  Future<void> call({required String recordId}) {
    return _repository.deleteMedicalRecord(recordId);
  }
} 