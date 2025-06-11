import 'package:medsync/data/models/dashboard_stats_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';

class GetPatientDashboardUseCase {
  final PatientRepository _repository;

  GetPatientDashboardUseCase(this._repository);

  Future<PatientDashboardData> call() {
    return _repository.getPatientDashboard();
  }
}