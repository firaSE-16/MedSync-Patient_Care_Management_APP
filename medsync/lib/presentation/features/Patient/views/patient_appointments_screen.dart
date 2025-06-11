import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medsync/presentation/features/patient/viewmodels/patient_appointments_viewmodel.dart';

class PatientAppointmentsScreen extends ConsumerStatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  ConsumerState<PatientAppointmentsScreen> createState() => _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends ConsumerState<PatientAppointmentsScreen> {
  String? _selectedFilterStatus; // null for all, 'scheduled', 'completed', 'cancelled'
  bool _showUpcomingOnly = false;

  @override
  void initState() {
    super.initState();
    // Initial fetch when the screen loads
    _fetchAppointments();
  }

  void _fetchAppointments() {
    ref.read(patientAppointmentsViewModelProvider.notifier).fetchAppointments(
      status: _selectedFilterStatus,
      upcoming: _showUpcomingOnly ? true : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsState = ref.watch(patientAppointmentsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAppointments,
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                _selectedFilterStatus = result == 'all' ? null : result;
                _fetchAppointments();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'all', child: Text('All')),
              const PopupMenuItem<String>(value: 'scheduled', child: Text('Scheduled')),
              const PopupMenuItem<String>(value: 'completed', child: Text('Completed')),
              const PopupMenuItem<String>(value: 'cancelled', child: Text('Cancelled')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
          Switch(
            value: _showUpcomingOnly,
            onChanged: (bool value) {
              setState(() {
                _showUpcomingOnly = value;
                _fetchAppointments();
              });
            },
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
          const Text('Upcoming'),
          const SizedBox(width: 8),
        ],
      ),
      body: appointmentsState.appointments.when(
        data: (appointments) {
          if (appointments.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appointment.doctorName ?? 'N/A'}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                         'Specialization N/A',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Icon(Icons.date_range, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            appointment.date,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            appointment.time,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(appointment.status.toUpperCase()),
                            backgroundColor: appointment.status == 'scheduled'
                                ? Colors.blue.shade100
                                : appointment.status == 'completed'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                            labelStyle: TextStyle(
                              color: appointment.status == 'scheduled'
                                  ? Colors.blue.shade800
                                  : appointment.status == 'completed'
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Notes: ${appointment.notes}',
                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}