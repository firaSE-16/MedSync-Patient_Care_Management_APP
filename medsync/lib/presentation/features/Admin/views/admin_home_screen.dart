import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/presentation/common/widgets/loading_indicator.dart';
import 'package:medsync/presentation/features/admin/viewmodels/admin_staff_viewmodel.dart';
import 'package:medsync/presentation/features/admin/viewmodels/admin_dashboard_viewmodel.dart';
import 'package:medsync/presentation/navigation/routes.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedRole = 'doctor'; // Default selected role for the home screen

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _fetchUsers(searchQuery: _searchController.text);
  }

  void _fetchUsers({String? searchQuery}) {
    if (selectedRole == 'patient') {
      ref.read(adminDashboardViewModelProvider.notifier).fetchPatients(search: searchQuery);
    } else {
      ref.read(adminStaffViewModelProvider.notifier).fetchStaffByCategory(selectedRole);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminStaffState = ref.watch(adminStaffViewModelProvider);
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
                  hintText: 'Search For Patients, Doctors, Or Reports...',
                  prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _fetchUsers();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEDE7F6),
                ),
                onChanged: (query) {
                  // _onSearchChanged handles this automatically due to listener
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black54),
                onPressed: () {
                  // TODO: Implement notification action
                },
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRoleFilterChip('doctor', 'Doctors'),
                _buildRoleFilterChip('triage', 'Triages'),
                _buildRoleFilterChip('admin', 'Admins'),
                _buildRoleFilterChip('patient', 'Patients'),
              ],
            ),
          ),
        ),
      ),
      body: Expanded(
        child: selectedRole == 'patient'
            ? adminDashboardState.patients.when(
                data: (users) {
                  if (users.isEmpty) {
                    return Center(child: Text('No $selectedRole found.'));
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _buildUserCard(user);
                    },
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
              )
            : adminStaffState.staffList.when(
                data: (users) {
                  if (users.isEmpty) {
                    return Center(child: Text('No $selectedRole found.'));
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _buildUserCard(user);
                    },
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
              ),
      ),
    );
  }

  Widget _buildRoleFilterChip(String role, String label) {
    bool isSelected = selectedRole == role;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            selectedRole = role;
            _searchController.clear();
          });
          _fetchUsers();
        }
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: const Color(0xFFEDE7F6),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).colorScheme.onPrimary : Colors.deepPurple,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  Widget _buildUserCard(UserModel user) {
    int? age;
    if (user.dateOfBirth != null) {
      final now = DateTime.now();
      age = now.year - user.dateOfBirth!.year;
      if (now.month < user.dateOfBirth!.month ||
          (now.month == user.dateOfBirth!.month &&
              now.day < user.dateOfBirth!.day)) {
        age--;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profileImageUrl ?? 'https://via.placeholder.com/150'), // Placeholder image
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    user.specialization ?? user.role.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  if (age != null) // Only show age if available
                    Text(
                      '$age Years Old',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  if (user.experienceYears != null) // Only show experience if available
                    Text(
                      '${user.experienceYears} Year Experience',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  Text(
                    user.phone ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        _buildRatingStar((user.rating ?? 0) >= i), // Dynamic stars
                      const SizedBox(width: 8),
                      Text('${user.rating?.toStringAsFixed(1) ?? 'N/A'}'),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: () {
                // Navigate to user detail
                context.go('${AppRoutes.adminStaff}/${user.id}'); // Reusing staff detail route for now
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStar(bool filled) {
    return Icon(
      filled ? Icons.star : Icons.star_border,
      color: Colors.amber,
      size: 20,
    );
  }
}
