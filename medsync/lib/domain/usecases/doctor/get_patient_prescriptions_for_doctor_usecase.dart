import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class GetPatientPrescriptionsForDoctorUseCase {
  final DoctorRepository _repository;

  GetPatientPrescriptionsForDoctorUseCase(this._repository);

  Future<List<PrescriptionModel>> call({required String patientId}) {
    return _repository.getPatientPrescriptionsForDoctor(patientId);
  }
} 