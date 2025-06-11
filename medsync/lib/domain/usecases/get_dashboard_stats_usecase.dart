import 'package:medsync/domain/repositories/admin_repository.dart';

class GetDashboardStatsUseCase {
  final AdminRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getDashboardStats();
  }
}