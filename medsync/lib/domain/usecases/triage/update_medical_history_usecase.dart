import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/domain/repositories/triage_repository.dart';

class UpdateMedicalHistoryUseCase {
  final TriageRepository repository;
  UpdateMedicalHistoryUseCase(this.repository);

  Future<MedicalHistoryModel> call({
    required String patientId,
    Map<String, dynamic>? updateData,
  }) {
    return repository.updateMedicalHistory(patientId: patientId, updateData: updateData);
  }
} 