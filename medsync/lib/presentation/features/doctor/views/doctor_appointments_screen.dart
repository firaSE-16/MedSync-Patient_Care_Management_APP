import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';

class DoctorAppointmentsScreen extends ConsumerStatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  ConsumerState<DoctorAppointmentsScreen> createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends ConsumerState<DoctorAppointmentsScreen> {
  String? _selectedStatus;
  DateTime? _selectedDate;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to ensure we're not in the build phase
    Future.microtask(() {
      if (!_isInitialized) {
        _fetchAppointments();
        _isInitialized = true;
      }
    });
  }

  void _fetchAppointments() {
    if (!mounted) return;
    ref.read(doctorViewModelProvider.notifier).fetchAppointments(
      status: _selectedStatus,
      date: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAppointments,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    value: _selectedStatus,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(value: 'scheduled', child: Text('Scheduled')),
                      DropdownMenuItem(value: 'completed', child: Text('Completed')),
                      DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                      DropdownMenuItem(value: 'no-show', child: Text('No Show')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                      _fetchAppointments();
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat.yMMMd().format(_selectedDate!),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                    _fetchAppointments();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: doctorState.appointments.when(
              data: (appointments) {
                if (appointments.isEmpty) {
                  return const Center(child: Text('No appointments found.'));
                }
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: ListTile(
                        title: Text('Patient: ${appointment.patientName ?? 'N/A'}'),
                        subtitle: Text(
                          'Date: ${DateFormat.yMMMd().format(DateTime.parse(appointment.date))} - ${appointment.time}\nStatus: ${appointment.status}',
                        ),
                        trailing: appointment.status == 'scheduled'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle, color: Colors.green),
                                    onPressed: () async {
                                      await ref.read(doctorViewModelProvider.notifier).updateAppointmentStatus(appointment.id, 'completed');
                                      _fetchAppointments();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () async {
                                      await ref.read(doctorViewModelProvider.notifier).updateAppointmentStatus(appointment.id, 'cancelled');
                                      _fetchAppointments();
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error loading appointments: ${e.toString()}')),
            ),
          ),
        ],
      ),
    );
  }
} 