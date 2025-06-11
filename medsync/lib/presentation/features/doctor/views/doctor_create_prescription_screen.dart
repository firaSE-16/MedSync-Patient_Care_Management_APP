import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';
import 'package:medsync/data/models/prescription_model.dart';

class DoctorCreatePrescriptionScreen extends ConsumerStatefulWidget {
  final String patientId;

  const DoctorCreatePrescriptionScreen({super.key, required this.patientId});

  @override
  ConsumerState<DoctorCreatePrescriptionScreen> createState() => _DoctorCreatePrescriptionScreenState();
}

class _DoctorCreatePrescriptionScreenState extends ConsumerState<DoctorCreatePrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicationsController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructionsController = TextEditingController();
  final List<Medication> _medications = [];

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
    final medication = Medication(
      name: _medicationsController.text,
      dosage: _dosageController.text,
      frequency: _frequencyController.text,
    );
    _medications.add(medication);
    ref.read(doctorViewModelProvider.notifier).addMedication(
          name: _medicationsController.text,
          dosage: _dosageController.text,
          frequency: _frequencyController.text,
        );
    _medicationsController.clear();
    _dosageController.clear();
    _frequencyController.clear();
    _durationController.clear();
    _instructionsController.clear();
  }

  void _removeMedication(int index) {
    ref.read(doctorViewModelProvider.notifier).removeMedication(index);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final medications = _medications.map((m) => m.toJson()).toList();
      ref.read(doctorViewModelProvider.notifier).createPrescription(
        patientId: widget.patientId,
        medications: medications,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Add Medications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(
                  labelText: 'Medication Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter medication name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _frequencyController,
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration',
                        border: OutlineInputBorder(),
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
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addMedication,
                child: const Text('Add Medication'),
              ),
              const SizedBox(height: 16),
              if (doctorState.patientPrescriptions?.value?.isNotEmpty == true) ...[
                const Text(
                  'Added Medications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctorState.patientPrescriptions?.value?.first.medications.length ?? 0,
                  itemBuilder: (context, index) {
                    final medication = doctorState.patientPrescriptions?.value?.first.medications[index];
                    return Card(
                      child: ListTile(
                        title: Text(medication?.name ?? 'N/A'),
                        subtitle: Text(
                          '${medication?.dosage ?? 'N/A'} - ${medication?.frequency ?? 'N/A'}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeMedication(index),
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Additional Instructions',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: doctorState.patientPrescriptions?.isLoading == true ? null : _submitForm,
                child: doctorState.patientPrescriptions?.isLoading == true
                    ? const CircularProgressIndicator()
                    : const Text('Create Prescription'),
              ),
              if (doctorState.patientPrescriptions?.hasError == true)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    doctorState.patientPrescriptions?.error.toString() ?? 'An error occurred',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 