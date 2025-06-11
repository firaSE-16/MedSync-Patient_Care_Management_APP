import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

class GetPatientAppointmentsUseCase {
  final PatientRepository _repository;

  GetPatientAppointmentsUseCase(this._repository);

  Future<List<AppointmentModel>> call({String? status, bool? upcoming}) {
    return _repository.getPatientAppointments(status: status, upcoming: upcoming);
  }
}