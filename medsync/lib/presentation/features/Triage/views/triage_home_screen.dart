import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/data/models/booking_model.dart'; // Assuming BookingModel has patientName and ailment (or similar)
import 'package:medsync/presentation/common/widgets/profile_icon.dart';
import 'package:medsync/presentation/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:medsync/presentation/features/triage/viewmodels/triage_unassigned_bookings_viewmodel.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class TriageHomeScreen extends ConsumerWidget {
  const TriageHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(triageUnassignedBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Triage - Unassigned Bookings'),
        // You might want to add a leading icon or actions here based on your app's design
      ),
      body: bookingsAsync.when(
        data: (bookings) => bookings.isEmpty
            ? const Center(child: Text('No unassigned bookings.'))
            : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  // Assuming your BookingModel has a property for ailment, e.g., `booking.ailment`
                  // If not, you'll need to adjust your BookingModel or derive this information.
                  final String patientAilment = booking.lookingFor; // Using lookingFor as ailment for demonstration

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      color: const Color(0xFFEDE7F6), // Light purple background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 0, // No shadow
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const ProfileIcon(), // Assuming ProfileIcon is a widget you have for the avatar
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Patient: ${booking.patientName}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF673AB7), // Darker purple for text
                                      ),
                                    ),
                                    Text(
                                      patientAilment,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54, // Slightly lighter for ailment
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 100, // Adjust width as needed
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.push('/triage/booking/${booking.id}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF673AB7), // Purple button color
                                    foregroundColor: Colors.white, // White text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    'View',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load bookings: $e')),
      ),
    );
  }
}