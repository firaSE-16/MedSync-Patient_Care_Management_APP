import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

class GetPatientBookingsUseCase {
  final PatientRepository _repository;

  GetPatientBookingsUseCase(this._repository);

  Future<List<BookingModel>> call({String? status}) async {
    return await _repository.getPatientBookings(status: status);
  }
} 