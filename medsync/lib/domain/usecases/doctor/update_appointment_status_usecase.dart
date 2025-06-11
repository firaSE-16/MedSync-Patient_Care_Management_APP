import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class UpdateAppointmentStatusUseCase {
  final DoctorRepository _repository;

  UpdateAppointmentStatusUseCase(this._repository);

  Future<AppointmentModel> call({required String appointmentId, required String status}) {
    return _repository.updateAppointmentStatus(appointmentId, status);
  }
} 