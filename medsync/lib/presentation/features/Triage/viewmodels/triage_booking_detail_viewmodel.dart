import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/core/providers.dart';

final triageAvailableDoctorsProvider = FutureProvider.autoDispose.family<List<UserModel>, String?>((ref, department) async {
  final useCase = ref.watch(getAvailableDoctorsUseCaseProvider);
  return await useCase.call(department: department);
});

final triageProcessBookingProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) async {
  final useCase = ref.watch(processTriageUseCaseProvider);
  return await useCase.call(
    bookingId: params['bookingId'],
    doctorId: params['doctorId'],
    vitals: params['vitals'],
    priority: params['priority'],
    notes: params['notes'],
  );
});

final triageUpdateMedicalHistoryProvider = FutureProvider.autoDispose.family<MedicalHistoryModel, Map<String, dynamic>>((ref, params) async {
  final useCase = ref.watch(updateMedicalHistoryUseCaseProvider);
  return await useCase.call(
    patientId: params['patientId'],
    updateData: params['updateData'],
  );
}); 