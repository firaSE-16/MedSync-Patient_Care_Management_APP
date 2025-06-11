import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

class GetPatientPrescriptionsUseCase {
  final PatientRepository _repository;

  GetPatientPrescriptionsUseCase(this._repository);

  Future<List<PrescriptionModel>> call() {
    return _repository.getPatientPrescriptions();
  }
}