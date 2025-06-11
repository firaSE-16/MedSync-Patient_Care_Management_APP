import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class CreatePrescriptionUseCase {
  final DoctorRepository _repository;

  CreatePrescriptionUseCase(this._repository);

  Future<PrescriptionModel> call({required String patientId, required List<Map<String, dynamic>> medications}) {
    return _repository.createPrescription(patientId: patientId, medications: medications);
  }
} 