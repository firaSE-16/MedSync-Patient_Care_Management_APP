import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/presentation/features/patient/viewmodels/patient_doctors_viewmodel.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class PatientDoctorsListScreen extends ConsumerWidget {
  const PatientDoctorsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsState = ref.watch(patientDoctorsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors to Chat With'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(patientDoctorsViewModelProvider.notifier).fetchDoctors(),
          ),
        ],
      ),
      body: doctorsState.doctors.when(
        data: (doctors) {
          if (doctors.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: "" != null
                        ? NetworkImage("")
                        : null,
                    child: "" == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                  title: Text('${doctor.name}'),
                  subtitle: Text('${doctor.specialization ?? 'N/A'} - ${doctor.department ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      // Navigate to the specific chat screen
                      context.go('${AppRoutes.patientChat}/${doctor.id}');
                    },
                  ),
                  onTap: () {
                    // You might also want to navigate to a doctor profile or just chat
                     context.go('${AppRoutes.patientChat}/${doctor.id}');
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}