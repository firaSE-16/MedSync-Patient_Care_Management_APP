import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/presentation/common/widgets/loading_indicator.dart';
import 'package:medsync/presentation/features/admin/viewmodels/admin_dashboard_viewmodel.dart'; // Using dashboard viewmodel for appointments

class AdminPatientAppointmentsView extends ConsumerStatefulWidget {
  const AdminPatientAppointmentsView({super.key});

  @override
  ConsumerState<AdminPatientAppointmentsView> createState() =>
      _AdminPatientAppointmentsViewState();
}

class _AdminPatientAppointmentsViewState
    extends ConsumerState<AdminPatientAppointmentsView> {
  String selectedStatus = 'upcoming'; // Default selected status

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  void _fetchAppointments() {
    ref
        .read(adminDashboardViewModelProvider.notifier)
        .fetchAppointmentsByStatus(selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final adminDashboardState = ref.watch(adminDashboardViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'All Appointment',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusFilterChip('completed', 'Complete'),
              _buildStatusFilterChip('scheduled', 'Upcoming'),
              _buildStatusFilterChip('cancelled', 'Cancelled'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: adminDashboardState.appointments.when(
              data: (appointments) {
                if (appointments.isEmpty) {
                  return const Center(child: Text('No appointments found.'));
                }
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return _buildAppointmentCard(appointment);
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChip(String status, String label) {
    bool isSelected = selectedStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            selectedStatus = status;
          });
          _fetchAppointments();
        }
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).colorScheme.onPrimary : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildAppointmentCard(dynamic appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Icon(Icons.person, size: 30, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient ${appointment.patientName ?? 'N/A'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    appointment.reason ?? 'N/A',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}