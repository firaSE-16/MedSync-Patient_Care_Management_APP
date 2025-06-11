import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/data/models/booking_model.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/presentation/features/triage/viewmodels/triage_unassigned_bookings_viewmodel.dart';
import 'package:medsync/presentation/features/triage/viewmodels/triage_booking_detail_viewmodel.dart';

class TriageBookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const TriageBookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<TriageBookingDetailScreen> createState() => _TriageBookingDetailScreenState();
}

class _TriageBookingDetailScreenState extends ConsumerState<TriageBookingDetailScreen> {
  String? selectedDoctorId;
  String? selectedPriority;
  final Map<String, dynamic> vitals = {};
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(triageUnassignedBookingsProvider);
    final availableDoctorsAsync = ref.watch(triageAvailableDoctorsProvider(null));

    return Scaffold(
      appBar: AppBar(title: const Text('Process Booking')),
      body: bookingsAsync.when(
        data: (bookings) {
          BookingModel? booking;
          try {
            booking = bookings.firstWhere((b) => b.id == widget.bookingId);
          } catch (_) {
            booking = null;
          }
          if (booking == null) {
            return const Center(child: Text('Booking not found.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Patient: ${booking.patientName}'),
                    subtitle: Text('Specialty: ${booking.lookingFor}\nDate: ${booking.preferredDate} Time: ${booking.preferredTime}'),
                  ),
                ),
                const SizedBox(height: 16),
                availableDoctorsAsync.when(
                  data: (doctors) => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Assign Doctor'),
                    value: selectedDoctorId,
                    items: doctors.map((UserModel doc) => DropdownMenuItem(
                      value: doc.id,
                      child: Text('${doc.name} (${doc.specialization ?? ''})'),
                    )).toList(),
                    onChanged: (val) => setState(() => selectedDoctorId = val),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => const Text('Could not load doctors.'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Priority'),
                  value: selectedPriority,
                  items: ['low', 'medium', 'high', 'emergency'].map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  )).toList(),
                  onChanged: (val) => setState(() => selectedPriority = val),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Vitals (JSON, e.g. {"bp": "120/80"})'),
                  onChanged: (val) {
                    try {
                      vitals.clear();
                      if (val.trim().isNotEmpty) {
                        vitals.addAll(val.trim().isNotEmpty ? Map<String, dynamic>.from(Uri.parse('?$val').queryParameters) : {});
                      }
                    } catch (_) {}
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: selectedDoctorId == null || selectedPriority == null
                      ? null
                      : () async {
                          final params = {
                            'bookingId': booking!.id,
                            'doctorId': selectedDoctorId,
                            'vitals': vitals,
                            'priority': selectedPriority,
                            'notes': notesController.text,
                          };
                          final result = await ref.read(triageProcessBookingProvider(params).future);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Triage processed successfully!')));
                            context.pop();
                          }
                        },
                  child: const Text('Process Triage'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Could not load booking.')),
      ),
    );
  }
} 