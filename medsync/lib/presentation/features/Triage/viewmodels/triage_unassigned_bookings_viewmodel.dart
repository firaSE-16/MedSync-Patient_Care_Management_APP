import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/core/providers.dart';

final triageUnassignedBookingsProvider = FutureProvider.autoDispose<List<BookingModel>>((ref) async {
  final useCase = ref.watch(getUnassignedBookingsUseCaseProvider);
  return await useCase.call();
}); 