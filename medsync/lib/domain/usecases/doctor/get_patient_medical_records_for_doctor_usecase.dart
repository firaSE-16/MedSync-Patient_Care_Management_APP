import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class GetPatientMedicalRecordsForDoctorUseCase {
  final DoctorRepository _repository;

  GetPatientMedicalRecordsForDoctorUseCase(this._repository);

  Future<List<MedicalHistoryModel>> call({required String patientId}) {
    return _repository.getPatientMedicalRecordsForDoctor(patientId);
  }
} 