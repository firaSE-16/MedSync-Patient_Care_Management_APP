import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class UpdateMedicalRecordUseCase {
  final DoctorRepository _repository;

  UpdateMedicalRecordUseCase(this._repository);

  Future<MedicalHistoryModel> call(
      {required String recordId, String? diagnosis, String? treatment, String? notes}) {
    return _repository.updateMedicalRecord(
        recordId,
        diagnosis: diagnosis,
        treatment: treatment,
        notes: notes);
  }
} 