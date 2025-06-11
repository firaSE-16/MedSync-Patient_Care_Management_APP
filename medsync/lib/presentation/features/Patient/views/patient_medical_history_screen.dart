import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medsync/data/models/medical_history_model.dart';
import 'package:medsync/presentation/features/Patient/viewmodels/patient_medical_history_viewmodel.dart';

class PatientMedicalHistoryScreen extends ConsumerWidget {
  const PatientMedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicalHistoryAsync = ref.watch(patientMedicalHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(patientMedicalHistoryProvider.future),
        child: medicalHistoryAsync.when(
          data: (history) => history.isEmpty
              ? const Center(
                  child: Text(
                    'No medical records found.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: history.length,
                  itemBuilder: (context, index) => _buildMedicalHistoryCard(history[index]),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryCard(MedicalHistoryModel history) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                  child: Text('${history.doctorName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(history.lastUpdated),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Diagnosis', history.diagnosis),
            const SizedBox(height: 8),
            _buildInfoRow('Treatment', history.treatment),
            if (history.notes != null && history.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Notes', history.notes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}