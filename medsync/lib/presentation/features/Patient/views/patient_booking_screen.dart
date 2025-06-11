import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medsync/core/providers.dart';

class Specialization {
  final String name;
  final IconData icon;
  final Color color;
  final int totalDoctors;

  Specialization({
    required this.name,
    required this.icon,
    required this.color,
    required this.totalDoctors,
  });
}

class PatientBookingScreen extends ConsumerStatefulWidget {
  const PatientBookingScreen({super.key});

  @override
  _PatientBookingScreenState createState() => _PatientBookingScreenState();
}

class _PatientBookingScreenState extends ConsumerState<PatientBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedSpecialization;
  TimeOfDay? _selectedTime;
  String? _selectedPriority;

  final List<Specialization> _specializations = [
    Specialization(
      name: 'Pathologist',
      icon: Icons.school,
      color: const Color(0xFF9B23B1),
      totalDoctors: 12,
    ),
    Specialization(
      name: 'Dermatologist',
      icon: Icons.medical_services,
      color: const Color(0xFFB19CD9),
      totalDoctors: 12,
    ),
    Specialization(
      name: 'Ophthalmologist',
      icon: Icons.remove_red_eye,
      color: const Color(0xFF9ACD32),
      totalDoctors: 12,
    ),
    Specialization(
      name: 'Pathologist',
      icon: Icons.biotech,
      color: const Color(0xFF5F9EA0),
      totalDoctors: 12,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onMonthChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        // Ensure time is formatted as HH:MM for backend compatibility
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _timeController.text = '${hour}:${minute}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Book Appointments',
          style: TextStyle(
            color: Color(0xFF7A6CF0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'What are You looking for?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement navigation to see all specializations
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFF7A6CF0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2, // Adjusted to better match image
                ),
                itemCount: _specializations.length,
                itemBuilder: (context, index) {
                  final specialization = _specializations[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSpecialization = specialization.name;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: specialization.color,
                        borderRadius: BorderRadius.circular(16),
                        border: _selectedSpecialization == specialization.name
                            ? Border.all(color: Colors.blue, width: 3) // Highlight selected
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(specialization.icon, color: Colors.white, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            specialization.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${specialization.totalDoctors} Total Doctor',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Calendar Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMM().format(_focusedDay),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                    _focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                    _focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Days of the week header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  // Calendar Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: DateUtils.getDaysInMonth(
                            _focusedDay.year, _focusedDay.month) +
                        _focusedDay.weekday - 1, // Number of empty cells before 1st day
                    itemBuilder: (context, index) {
                      final firstDayOfMonth = DateTime(
                          _focusedDay.year, _focusedDay.month, 1);
                      final displayDate = firstDayOfMonth.add(Duration(
                          days: index - (firstDayOfMonth.weekday - 1)));

                      final isToday = DateUtils.isSameDay(displayDate, DateTime.now());
                      final isSelected = DateUtils.isSameDay(displayDate, _selectedDay);
                      final isCurrentMonth = displayDate.month == _focusedDay.month;

                      return GestureDetector(
                        onTap: () {
                          if (isCurrentMonth) {
                            _onDaySelected(displayDate, _focusedDay);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected && isCurrentMonth
                                ? const Color(0xFF7A6CF0) // Selected date background
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: isToday && isCurrentMonth && !isSelected
                                ? Border.all(color: Colors.black, width: 1.5)
                                : null,
                          ),
                          child: Text(
                            isCurrentMonth ? '${displayDate.day}' : '',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isCurrentMonth
                                      ? Colors.black
                                      : Colors.grey.withOpacity(0.5),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Re-introducing other fields
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) => value!.isEmpty ? 'Please select a time' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.priority_high),
                ),
                value: _selectedPriority,
                items: ['low', 'medium', 'high', 'emergency'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPriority = value),
                validator: (value) => value == null ? 'Please select a priority' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Patient ID/Name',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  hintText: user?.name ?? 'N/A', // Display user's name as hint
                ),
                readOnly: true, // Display only, not for manual input
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _selectedSpecialization != null &&
                      _selectedDay != null &&
                      _selectedTime != null) {
                    try {
                      await ref.read(createBookingUseCaseProvider).call(
                            lookingFor: _selectedSpecialization!,
                            preferredDate: DateFormat('yyyy-MM-dd').format(_selectedDay!),
                            preferredTime: _timeController.text,
                            priority: _selectedPriority,
                            notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                            patientName: user?.name,
                          );

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booking created successfully!')));

                      // Refresh bookings data (if needed)
                      // ref.refresh(patientBookingsProvider(null));

                      // Clear form fields
                      _timeController.clear();
                      _notesController.clear();
                      setState(() {
                        _selectedDay = DateTime.now();
                        _focusedDay = DateTime.now();
                        _selectedSpecialization = null;
                        _selectedTime = null;
                        _selectedPriority = null;
                      });

                    } catch (e) {
                      print('Booking Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create booking: $e')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}