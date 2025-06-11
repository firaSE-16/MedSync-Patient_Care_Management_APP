import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/data/models/appointment_model.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class DoctorHomeScreen extends ConsumerStatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  ConsumerState<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends ConsumerState<DoctorHomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Initial fetch for date: ${_selectedDate.toIso8601String()}');
      _fetchAppointmentsForSelectedDate();
    });
  }

  void _fetchAppointmentsForSelectedDate() {
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    print('Fetching appointments for formatted date: $formattedDate');
    ref.read(doctorViewModelProvider.notifier).fetchAppointments(date: formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authProvider);
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Profile, Name, Notifications, Settings
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(Icons.person, size: 32, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: userAsync.when(
                      data: (user) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hi, Welcome Back',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            '${user?.name ?? 'Doctor'}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      loading: () => const Text('Loading...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      error: (e, s) => const Text('Error', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 28),
                    onPressed: () {
                      // TODO: Implement notification navigation
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, size: 28),
                    onPressed: () {
                      // TODO: Implement settings navigation
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Search Bar with Filters
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Implement Patients filter
                            },
                            icon: Icon(Icons.people_alt, color: Theme.of(context).primaryColor),
                            label: Text(
                              'Patients',
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                suffixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.filter_list_alt, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Date Selector (Horizontal Days)
              SizedBox(
                height: 90, // Height for the date cards
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7, // Display 7 days from today
                  itemBuilder: (context, index) {
                    final date = DateTime.now().add(Duration(days: index));
                    final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          print('Date selected: ${_selectedDate.toIso8601String()}');
                          _fetchAppointmentsForSelectedDate(); // Fetch appointments for new date
                        });
                      },
                      child: Container(
                        width: 70, // Width of each date card
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('EEE').format(date).toUpperCase(), // Mon, Tue, etc.
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Appointments Timeline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0), // Align with date cards
                child: Text(
                  '${DateFormat('EEEE - MMMM d').format(_selectedDate)} - Today',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              doctorState.appointments.when(
                data: (appointments) {
                  // Filter appointments for the selected date and status 'scheduled'
                  final appointmentsForSelectedDate = appointments.where((appt) {
                    final apptDate = DateTime.parse(appt.date); // Parse the date string from the appointment
                    return apptDate.year == _selectedDate.year &&
                           apptDate.month == _selectedDate.month &&
                           apptDate.day == _selectedDate.day &&
                           appt.status == 'scheduled'; // Only show scheduled appointments
                  }).toList();

                  if (appointmentsForSelectedDate.isEmpty) {
                    return const Center(
                      child: Text('No upcoming appointments for this date.'),
                    );
                  }

                  // Group appointments by time (e.g., 9 AM, 10 AM)
                  final Map<String, List<AppointmentModel>> groupedAppointments = {};
                  for (var appt in appointmentsForSelectedDate) {
                    final timeSlot = DateFormat('h a').format(DateFormat('HH:mm').parse(appt.time));
                    print('Appointment for ${appt.patientName} at ${appt.time} on ${appt.date} - Status: ${appt.status}. Generated time slot: $timeSlot');
                    groupedAppointments.putIfAbsent(timeSlot, () => []).add(appt);
                  }

                  // Define typical time slots
                  final List<String> timeSlots = [
                    '12 AM', '1 AM', '2 AM', '3 AM', '4 AM', '5 AM', '6 AM', '7 AM', '8 AM',
                    '9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM',
                    '6 PM', '7 PM', '8 PM', '9 PM', '10 PM', '11 PM',
                  ];

                  return Column(
                    children: timeSlots.map((time) {
                      final apptsInSlot = groupedAppointments[time];
                      print('Checking time slot $time. Appointments in slot: ${apptsInSlot?.length ?? 0}');
                      if (apptsInSlot != null && apptsInSlot.isNotEmpty) {
                        return Column(
                          children: apptsInSlot.map((appt) {
                            return _buildTimeSlot(
                              context,
                              time,
                              appt.patientName ?? 'N/A',
                              appt.reason ?? 'No reason provided',
                              appt.status == 'completed' ? Icons.check_circle_outline : Icons.cancel_outlined, // Icon based on status
                            );
                          }).toList(),
                        );
                      } else {
                        return _buildTimeSlot(context, time, null, null, null);
                      }
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error loading appointments: ${e.toString()}'),
              ),
              const SizedBox(height: 24),
              // My Patients Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0), // Align with date cards
                child: Text(
                  'My Patients',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              doctorState.patients.when(
                data: (patients) {
                  if (patients.isEmpty) {
                    return const Text('No patients assigned yet.');
                  }
                  return Column(
                    children: patients.map((patient) => _buildPatientCard(context, patient)).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Text('Error loading patients.'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlot(BuildContext context, String time, String? patientName, String? reason, IconData? statusIcon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: patientName != null ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: patientName != null
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patientName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          if (reason != null)
                            Text(
                              reason,
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                        ],
                      ),
                    ),
                    if (statusIcon != null) Icon(statusIcon, color: Theme.of(context).primaryColor),
                  ],
                )
              : Text(
                  '-------------------------------------------', // Dotted line placeholder
                  style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPatientCard(BuildContext context, dynamic patient) {
    return GestureDetector(
      onTap: () {
        if (patient.id != null && patient.id.isNotEmpty) {
          print('Navigating to patient detail for ID: ${patient.id}');
          context.push(AppRoutes.patientDetail.replaceFirst(':id', patient.id));
        } else {
          print('Patient ID is null or empty. Cannot navigate.');
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(Icons.person, size: 28, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name ?? 'Patient Name',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'No specific condition',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                onPressed: () {
                  // TODO: Implement info button action
                },
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                onPressed: () {
                  // TODO: Implement calendar button action
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border, color: Theme.of(context).primaryColor),
                onPressed: () {
                  // TODO: Implement favorite button action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 