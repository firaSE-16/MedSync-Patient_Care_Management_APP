import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medsync/presentation/features/patient/viewmodels/patient_prescriptions_viewmodel.dart';

class PatientPrescriptionsScreen extends ConsumerWidget {
  const PatientPrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptionsState = ref.watch(patientPrescriptionsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(patientPrescriptionsViewModelProvider.notifier).fetchPrescriptions(),
          ),
        ],
      ),
      body: prescriptionsState.prescriptions.when(
        data: (prescriptions) {
          if (prescriptions.isEmpty) {
            return const Center(child: Text('No prescriptions found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = prescriptions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prescription from ${prescription.doctorName ?? 'N/A'}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${DateFormat.yMd().format(prescription.createdAt)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const Divider(),
                      if (prescription.medications.isEmpty)
                        const Text('No medications listed for this prescription.')
                      else
                        ...prescription.medications.map((medication) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${medication.name ?? 'N/A'} - ${medication.dosage ?? 'N/A'}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text('Frequency: ${medication.frequency ?? 'N/A'}'),
                                  if (medication.description != null &&
                                      medication.description!.isNotEmpty)
                                    Text('Notes: ${medication.description}'),
                                  if (medication.price != null)
                                    Text('Price: \$${medication.price!.toStringAsFixed(2)}'),
                                ],
                              ),
                            )),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }
}