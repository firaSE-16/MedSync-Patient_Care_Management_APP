import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/domain/repositories/patient_repository.dart';
import 'package:medsync/domain/usecases/patient/create_booking_usecase.dart';
import 'package:medsync/domain/usecases/patient/cancel_booking_usecase.dart';
import 'package:medsync/core/providers.dart';

class PatientBookingState {
  final AsyncValue<BookingModel?> currentBookingOperation; // For create/cancel status
  final AsyncValue<List<BookingModel>> patientBookings; // For fetching all bookings

  PatientBookingState({
    required this.currentBookingOperation,
    required this.patientBookings,
  });

  PatientBookingState copyWith({
    AsyncValue<BookingModel?>? currentBookingOperation,
    AsyncValue<List<BookingModel>>? patientBookings,
  }) {
    return PatientBookingState(
      currentBookingOperation: currentBookingOperation ?? this.currentBookingOperation,
      patientBookings: patientBookings ?? this.patientBookings,
    );
  }
}

final patientBookingViewModelProvider =
    StateNotifierProvider<PatientBookingViewModel, PatientBookingState>(
  (ref) {
    final createBookingUseCase = ref.read(createBookingUseCaseProvider);
    final cancelBookingUseCase = ref.read(cancelBookingUseCaseProvider);
    final patientRepository = ref.read(patientRepositoryProvider); // For fetching all bookings
    return PatientBookingViewModel(createBookingUseCase, cancelBookingUseCase, patientRepository);
  },
);

class PatientBookingViewModel extends StateNotifier<PatientBookingState> {
  final CreateBookingUseCase _createBookingUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;
  final PatientRepository _patientRepository; // Directly use repository for list fetching

  PatientBookingViewModel(this._createBookingUseCase, this._cancelBookingUseCase, this._patientRepository)
      : super(PatientBookingState(
          currentBookingOperation: const AsyncValue.data(null),
          patientBookings: const AsyncValue.loading(),
        )) {
          fetchPatientBookings(); // Fetch initial bookings
        }

  Future<void> createBooking({
    required String lookingFor,
    required String preferredDate,
    required String preferredTime,
    String? priority,
    String? notes,
    String? patientName,
  }) async {
    state = state.copyWith(currentBookingOperation: const AsyncValue.loading());
    try {
      final newBooking = await _createBookingUseCase.call(
        lookingFor: lookingFor,
        preferredDate: preferredDate,
        preferredTime: preferredTime,
        priority: priority,
        notes: notes,
        patientName: patientName,
      );
      state = state.copyWith(currentBookingOperation: AsyncValue.data(newBooking));
      // Refresh the list of bookings after creation
      await fetchPatientBookings();
    } catch (e, st) {
      state = state.copyWith(currentBookingOperation: AsyncValue.error(e, st));
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    state = state.copyWith(currentBookingOperation: const AsyncValue.loading());
    try {
      final cancelledBooking = await _cancelBookingUseCase.call(bookingId);
      state = state.copyWith(currentBookingOperation: AsyncValue.data(cancelledBooking));
      // Refresh the list of bookings after cancellation
      await fetchPatientBookings();
    } catch (e, st) {
      state = state.copyWith(currentBookingOperation: AsyncValue.error(e, st));
    }
  }

  Future<void> fetchPatientBookings({String? status}) async {
    state = state.copyWith(patientBookings: const AsyncValue.loading());
    try {
      final bookings = await _patientRepository.getPatientBookings(status: status);
      state = state.copyWith(patientBookings: AsyncValue.data(bookings));
    } catch (e, st) {
      state = state.copyWith(patientBookings: AsyncValue.error(e, st));
    }
  }
}