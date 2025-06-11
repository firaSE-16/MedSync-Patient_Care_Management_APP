import 'package:medsync/domain/repositories/doctor_repository.dart';

class DeletePrescriptionUseCase {
  final DoctorRepository _repository;

  DeletePrescriptionUseCase(this._repository);

  Future<void> call({required String prescriptionId}) {
    return _repository.deletePrescription(prescriptionId);
  }
} 