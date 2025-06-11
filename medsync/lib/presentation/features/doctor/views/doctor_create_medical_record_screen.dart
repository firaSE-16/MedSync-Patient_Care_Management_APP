import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/providers.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';

class DoctorCreateMedicalRecordScreen extends ConsumerStatefulWidget {
  final String patientId;

  const DoctorCreateMedicalRecordScreen({super.key, required this.patientId});

  @override
  ConsumerState<DoctorCreateMedicalRecordScreen> createState() => _DoctorCreateMedicalRecordScreenState();
}

class _DoctorCreateMedicalRecordScreenState extends ConsumerState<DoctorCreateMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref.read(doctorViewModelProvider.notifier).createMedicalRecord(
        patientId: widget.patientId as String,
        diagnosis: _diagnosisController.text,
        treatment: _treatmentController.text,
        notes: _notesController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Medical Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _diagnosisController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter diagnosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _treatmentController,
                decoration: const InputDecoration(
                  labelText: 'Treatment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter treatment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: doctorState.patientMedicalRecords?.isLoading ?? false ? null : _submitForm,
                child: doctorState.patientMedicalRecords?.isLoading ?? false
                    ? const CircularProgressIndicator()
                    : const Text('Create Record'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
} 