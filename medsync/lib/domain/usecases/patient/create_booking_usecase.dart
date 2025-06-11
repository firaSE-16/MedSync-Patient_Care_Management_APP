import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

class CreateBookingUseCase {
  final PatientRepository _repository;

  CreateBookingUseCase(this._repository);

  Future<BookingModel> call({
    required String lookingFor,
    required String preferredDate,
    required String preferredTime,
    String? priority,
    String? notes,
    String? patientName,
  }) {
    return _repository.createBooking(
      lookingFor: lookingFor,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      priority: priority,
      notes: notes,
      patientName: patientName,
    );
  }
}