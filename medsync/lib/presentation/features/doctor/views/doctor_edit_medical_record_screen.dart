import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';

class DoctorEditMedicalRecordScreen extends ConsumerStatefulWidget {
  final String recordId;
  final String patientId;

  const DoctorEditMedicalRecordScreen({super.key, required this.recordId, required this.patientId});

  @override
  ConsumerState<DoctorEditMedicalRecordScreen> createState() => _DoctorEditMedicalRecordScreenState();
}

class _DoctorEditMedicalRecordScreenState extends ConsumerState<DoctorEditMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorViewModelProvider.notifier).fetchMedicalRecordDetails(widget.recordId);
    });
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref.read(doctorViewModelProvider.notifier).updateMedicalRecord(
        patientId: widget.patientId,
        widget.recordId,
        diagnosis: _diagnosisController.text,
        treatment: _treatmentController.text,
        notes: _notesController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Medical Record'),
      ),
      body: doctorState.selectedMedicalRecord?.when(
        data: (record) {
          if (record == null) {
            return const Center(child: Text('Record not found.'));
          }
          // Pre-fill form fields with existing record data
          _diagnosisController.text = record.diagnosis;
          _treatmentController.text = record.treatment;
          _notesController.text = record.notes ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medical Record Details',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Update the patient\'s medical record information below.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Diagnosis Field
                    Text(
                      'Diagnosis',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _diagnosisController,
                      decoration: InputDecoration(
                        hintText: 'Enter the diagnosis',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter diagnosis';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Treatment Field
                    Text(
                      'Treatment',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _treatmentController,
                      decoration: InputDecoration(
                        hintText: 'Enter the treatment plan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter treatment';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Notes Field
                    Text(
                      'Additional Notes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Enter any additional notes or observations',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: doctorState.patientMedicalRecords?.isLoading ?? false ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: doctorState.patientMedicalRecords?.isLoading ?? false
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update Record',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    if (doctorState.patientMedicalRecords?.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  doctorState.patientMedicalRecords!.error.toString(),
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[700]),
                const SizedBox(height: 16),
                Text(
                  'Error loading record: ${e.toString()}',
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ) ?? const Center(child: CircularProgressIndicator()),
    );
  }
} 