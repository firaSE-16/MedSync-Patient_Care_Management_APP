import 'package:medsync/domain/repositories/triage_repository.dart';

class ProcessTriageUseCase {
  final TriageRepository repository;
  ProcessTriageUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String bookingId,
    required String doctorId,
    required Map<String, dynamic> vitals,
    required String priority,
    String? notes,
  }) {
    return repository.processTriage(
      bookingId: bookingId,
      doctorId: doctorId,
      vitals: vitals,
      priority: priority,
      notes: notes,
    );
  }
} 