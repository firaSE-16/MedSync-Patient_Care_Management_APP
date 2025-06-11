import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/presentation/common/widgets/loading_indicator.dart';
import 'package:medsync/presentation/features/admin/viewmodels/admin_dashboard_viewmodel.dart'; // Using dashboard viewmodel for patients
import 'package:go_router/go_router.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class AdminPatientsView extends ConsumerStatefulWidget {
  const AdminPatientsView({super.key});

  @override
  ConsumerState<AdminPatientsView> createState() => _AdminPatientsViewState();
}

class _AdminPatientsViewState extends ConsumerState<AdminPatientsView> {
  final TextEditingController _searchController = TextEditingController();
  String? currentSearchQuery;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  void _fetchPatients() {
    ref
        .read(adminDashboardViewModelProvider.notifier)
        .fetchPatients(search: currentSearchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminDashboardState = ref.watch(adminDashboardViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search For Patients...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        currentSearchQuery = null; // Clear search query
                      });
                      _fetchPatients();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (query) {
                  setState(() {
                    currentSearchQuery = query;
                  });
                  _fetchPatients();
                },
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                // TODO: Implement notification action
              },
            ),
          ],
        ),
      ),
      body: adminDashboardState.patients.when(
        data: (patients) {
          if (patients.isEmpty) {
            return const Center(child: Text('No patients found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0), // Add padding here
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return _buildPatientCard(patient);
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }

  Widget _buildPatientCard(UserModel patient) {
    int? age;
    if (patient.dateOfBirth != null) {
      final now = DateTime.now();
      age = now.year - patient.dateOfBirth!.year;
      if (now.month < patient.dateOfBirth!.month ||
          (now.month == patient.dateOfBirth!.month &&
              now.day < patient.dateOfBirth!.day)) {
        age--;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(patient.profileImageUrl ?? 'https://via.placeholder.com/150'), // Placeholder image
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    patient.email ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  if (age != null)
                    Text(
                      '$age Years Old',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  Text(
                    patient.phone ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: () {
                // Navigate to patient detail
                context.go('${AppRoutes.adminStaff}/${patient.id}'); // Reusing staff detail route for now
              },
            ),
          ],
        ),
      ),
    );
  }
}