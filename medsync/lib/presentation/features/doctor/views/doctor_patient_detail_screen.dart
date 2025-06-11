import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/presentation/navigation/routes.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';

class DoctorPatientDetailScreen extends ConsumerStatefulWidget {
  final String patientId;

  const DoctorPatientDetailScreen({super.key, required this.patientId});

  @override
  ConsumerState<DoctorPatientDetailScreen> createState() => _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends ConsumerState<DoctorPatientDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to ensure we're not in the build phase
    Future.microtask(() {
      final notifier = ref.read(doctorViewModelProvider.notifier);
      notifier.fetchPatientDetails(widget.patientId);
      notifier.fetchPatientMedicalRecords(widget.patientId);
      notifier.fetchPatientPrescriptions(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);
    final notifier = ref.read(doctorViewModelProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              notifier.fetchPatientDetails(widget.patientId);
              notifier.fetchPatientMedicalRecords(widget.patientId);
              notifier.fetchPatientPrescriptions(widget.patientId);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  doctorState.selectedPatient?.when(
                    data: (patientDetails) {
                      if (patientDetails == null) {
                        return const Text('No details found.');
                      }
                      return Column(
                        children: [
                          Text(
                            patientDetails['name'] ?? 'N/A',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            patientDetails['email'] ?? 'N/A',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Error loading patient details: ${e.toString()}'),
                  ) ?? const Text('Loading...'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Info Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient Information',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          doctorState.selectedPatient?.when(
                            data: (patientDetails) {
                              if (patientDetails == null) {
                                return const Text('No details found.');
                              }
                              return Column(
                                children: [
                                  _buildInfoRow('Gender', patientDetails['gender'] ?? 'N/A'),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('Date of Birth', patientDetails['dateOfBirth'] ?? 'N/A'),
                                ],
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (e, s) => Text('Error loading patient details: ${e.toString()}'),
                          ) ?? const Text('Loading...'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Medical Records Section
                  Text(
                    'Medical Records',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  doctorState.patientMedicalRecords?.when(
                    data: (records) {
                      if (records.isEmpty) {
                        return const Center(
                          child: Text('No medical records found.'),
                        );
                      }
                      return Column(
                        children: records.map((record) => Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Diagnosis',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            record.diagnosis ?? 'No diagnosis provided',
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            context.push('${AppRoutes.doctorEditMedicalRecord.replaceFirst(':id', record.id)}?patientId=${widget.patientId}');
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            notifier.deleteMedicalRecord(record.id, patientId: widget.patientId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Treatment',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  record.treatment ?? 'No treatment provided',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        )).toList(),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text('Error loading medical records: ${e.toString()}')),
                  ) ?? const Center(child: Text('Loading...')),

                  const SizedBox(height: 24),

                  // Prescriptions Section
                  Text(
                    'Prescriptions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  doctorState.patientPrescriptions?.when(
                    data: (prescriptions) {
                      if (prescriptions.isEmpty) {
                        return const Center(
                          child: Text('No prescriptions found.'),
                        );
                      }
                      return Column(
                        children: prescriptions.map((prescription) => Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Prescription #${prescription.id ?? 'N/A'}',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${prescription.medications?.length ?? 0} medications',
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            context.push(AppRoutes.doctorEditPrescription.replaceFirst(':id', prescription.id ?? ''));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            if (prescription.id != null) {
                                              notifier.deletePrescription(prescription.id!);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )).toList(),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text('Error loading prescriptions: ${e.toString()}')),
                  ) ?? const Center(child: Text('Loading...')),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          context.push('${AppRoutes.doctorCreateMedicalRecord}?patientId=${widget.patientId}');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Medical Record'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.push('${AppRoutes.doctorCreatePrescription}?patientId=${widget.patientId}');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Prescription'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}