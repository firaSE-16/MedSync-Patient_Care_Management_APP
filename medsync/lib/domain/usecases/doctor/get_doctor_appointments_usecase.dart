import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/domain/repositories/doctor_repository.dart';

class GetDoctorAppointmentsUseCase {
  final DoctorRepository _repository;

  GetDoctorAppointmentsUseCase(this._repository);

  Future<List<AppointmentModel>> call({String? status, String? date}) {
    return _repository.getDoctorAppointments(status: status, date: date);
  }
} 