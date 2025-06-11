import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/data/models/prescription_model.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';

class DoctorEditPrescriptionScreen extends ConsumerStatefulWidget {
  final String prescriptionId;

  const DoctorEditPrescriptionScreen({super.key, required this.prescriptionId});

  @override
  ConsumerState<DoctorEditPrescriptionScreen> createState() => _DoctorEditPrescriptionScreenState();
}

class _DoctorEditPrescriptionScreenState extends ConsumerState<DoctorEditPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicationsController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructionsController = TextEditingController();
  late List<Medication> _medications;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorViewModelProvider.notifier).fetchPrescriptionDetails(widget.prescriptionId);
    });
  }

  @override
  void dispose() {
    _medicationsController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _addMedication() {
    if (_medicationsController.text.isNotEmpty &&
        _dosageController.text.isNotEmpty &&
        _frequencyController.text.isNotEmpty) {
      ref.read(doctorViewModelProvider.notifier).addMedication(
        name: _medicationsController.text,
        dosage: _dosageController.text,
        frequency: _frequencyController.text,
      );

      // Clear controllers
      _medicationsController.clear();
      _dosageController.clear();
      _frequencyController.clear();
      _durationController.clear();
    }
  }

  void _removeMedication(int index) {
    ref.read(doctorViewModelProvider.notifier).removeMedication(index);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final medications = _medications.map((m) => m.toJson()).toList();
      ref.read(doctorViewModelProvider.notifier).updatePrescription(
        widget.prescriptionId,
        medications: medications,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Prescription'),
      ),
      body: doctorState.selectedPrescription?.when(
        data: (prescription) {
          if (prescription == null) {
            return const Center(child: Text('Prescription not found.'));
          }
          // Pre-fill form fields with existing prescription data
          _medications = prescription.medications;
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
                            'Prescription Details',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Update the patient\'s prescription information below.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Add Medication Section
                    Text(
                      'Add New Medication',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            TextFormField(
                              controller: _medicationsController,
                              decoration: InputDecoration(
                                labelText: 'Medication Name',
                                hintText: 'Enter medication name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter medication name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _dosageController,
                                    decoration: InputDecoration(
                                      labelText: 'Dosage',
                                      hintText: 'e.g., 500mg',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _frequencyController,
                                    decoration: InputDecoration(
                                      labelText: 'Frequency',
                                      hintText: 'e.g., Twice daily',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _durationController,
                                    decoration: InputDecoration(
                                      labelText: 'Duration',
                                      hintText: 'e.g., 7 days',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _addMedication,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Medication'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Current Medications Section
                    if (doctorState.patientPrescriptions?.value?.isNotEmpty == true) ...[
                      Text(
                        'Current Medications',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: doctorState.patientPrescriptions?.value?.first.medications.length ?? 0,
                        itemBuilder: (context, index) {
                          final medication = doctorState.patientPrescriptions?.value?.first.medications[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medication?.name ?? 'N/A',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${medication?.dosage ?? 'N/A'} - ${medication?.frequency ?? 'N/A'}',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.red,
                                    onPressed: () => _removeMedication(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 32),

                    // Additional Instructions Section
                    Text(
                      'Additional Instructions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _instructionsController,
                      decoration: InputDecoration(
                        hintText: 'Enter any additional instructions for the patient',
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
                        onPressed: doctorState.patientPrescriptions?.isLoading == true ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: doctorState.patientPrescriptions?.isLoading == true
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update Prescription',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    if (doctorState.patientPrescriptions?.hasError == true)
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
                                  doctorState.patientPrescriptions?.error.toString() ?? 'An error occurred',
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
        error: (error, stack) => Center(
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
                  'Error loading prescription: $error',
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(doctorViewModelProvider.notifier).fetchPrescriptionDetails(widget.prescriptionId);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 