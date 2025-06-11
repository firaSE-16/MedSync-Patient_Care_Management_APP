import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class GetPrescriptionDetailsUseCase {
  final DoctorRepository _repository;

  GetPrescriptionDetailsUseCase(this._repository);

  Future<PrescriptionModel> call({required String prescriptionId}) {
    return _repository.getPrescriptionDetails(prescriptionId);
  }
} 