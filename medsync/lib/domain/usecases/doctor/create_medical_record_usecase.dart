import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class CreateMedicalRecordUseCase {
  final DoctorRepository _repository;

  CreateMedicalRecordUseCase(this._repository);

  Future<MedicalHistoryModel> call({
    required String patientId,
    required String diagnosis,
    required String treatment,
    String? notes,
  }) {
    return _repository.createMedicalRecord(
      patientId: patientId,
      diagnosis: diagnosis,
      treatment: treatment,
      notes: notes,
    );
  }
} 