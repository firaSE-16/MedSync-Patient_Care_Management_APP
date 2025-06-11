import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class GetMedicalRecordDetailsUseCase {
  final DoctorRepository _repository;

  GetMedicalRecordDetailsUseCase(this._repository);

  Future<MedicalHistoryModel> call({required String recordId}) {
    return _repository.getMedicalRecordDetails(recordId);
  }
} 