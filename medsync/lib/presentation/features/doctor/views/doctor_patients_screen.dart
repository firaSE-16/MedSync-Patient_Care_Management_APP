import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/presentation/features/doctor/viewmodels/doctor_viewmodel.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class DoctorPatientsScreen extends ConsumerWidget {
  const DoctorPatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(doctorViewModelProvider);
            },
          ),
        ],
      ),
      body: doctorState.patients.when(
        data: (patients) {
          if (patients.isEmpty) {
            return const Center(child: Text('No patients assigned yet.'));
          }
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  title: Text(patient.name),
                  subtitle: Text('Email: ${patient.email}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.push(AppRoutes.patientDetail.replaceFirst(':id', patient.id));
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading patients: ${e.toString()}')),
      ),
    );
  }
} 