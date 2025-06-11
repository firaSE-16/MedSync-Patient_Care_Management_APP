import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/domain/repositories/triage_repository.dart';

class GetUnassignedBookingsUseCase {
  final TriageRepository repository;
  GetUnassignedBookingsUseCase(this.repository);

  Future<List<BookingModel>> call({int page = 1, int limit = 10}) {
    return repository.getUnassignedBookings(page: page, limit: limit);
  }
} 