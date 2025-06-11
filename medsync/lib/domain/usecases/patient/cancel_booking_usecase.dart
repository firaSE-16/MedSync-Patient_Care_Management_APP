import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

class CancelBookingUseCase {
  final PatientRepository _repository;

  CancelBookingUseCase(this._repository);

  Future<BookingModel> call(String bookingId) {
    return _repository.cancelBooking(bookingId);
  }
}