import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/domain/repositories/admin_repository.dart';

class GetAppointmentsByStatusUseCase {
  final AdminRepository repository;

  GetAppointmentsByStatusUseCase(this.repository);

  Future<List<AppointmentModel>> call(
      {String? status, int page = 1, int limit = 10}) {
    return repository.getAppointmentsByStatus(
        status: status, page: page, limit: limit);
  }
}