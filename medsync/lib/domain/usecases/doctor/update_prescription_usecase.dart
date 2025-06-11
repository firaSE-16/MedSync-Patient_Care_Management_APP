import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class UpdatePrescriptionUseCase {
  final DoctorRepository _repository;

  UpdatePrescriptionUseCase(this._repository);

  Future<PrescriptionModel> call({required String prescriptionId, required List<Map<String, dynamic>> medications}) {
    return _repository.updatePrescription(prescriptionId, medications: medications);
  }
} 