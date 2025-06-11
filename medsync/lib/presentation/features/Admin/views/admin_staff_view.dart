import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/data/models/user_model.dart';
import 'package:medsync/presentation/common/widgets/custom_button.dart';
import 'package:medsync/presentation/features/admin/viewmodels/admin_staff_viewmodel.dart';

class AdminStaffView extends ConsumerStatefulWidget {
  const AdminStaffView({super.key});

  @override
  ConsumerState<AdminStaffView> createState() => _AdminStaffViewState();
}

class _AdminStaffViewState extends ConsumerState<AdminStaffView> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  String _role = 'doctor'; // Default role
  String? _specialization;
  DateTime? _dateOfBirth;

  @override
  Widget build(BuildContext context) {
    final adminStaffState = ref.watch(adminStaffViewModelProvider);

    ref.listen<AsyncValue<UserModel?>>(
      adminStaffViewModelProvider.select((state) => state.registeredStaff),
      (previous, next) {
        next.whenOrNull(
          data: (staff) {
            if (staff != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Staff ${staff.name} registered successfully!'))
              );
            }
          },
          error: (e, st) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error registering staff: ${e.toString()}'))
            );
          },
        );
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'FullName',
                hintText: 'E.g., Alex Johnson',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              validator: (value) => value!.isEmpty ? 'Please enter full name' : null,
              onSaved: (value) => _name = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'E.g., you@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value!.isEmpty ? 'Please enter email' : null,
              onSaved: (value) => _email = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '********',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Please enter password' : null,
              onSaved: (value) => _password = value,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: InputDecoration(
                labelText: 'Role',
                hintText: 'E.g., Doctor,Triage,Admin',
                prefixIcon: const Icon(Icons.group_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: const [
                DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
                DropdownMenuItem(value: 'triage', child: Text('Triage')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _role = value;
                  });
                }
              },
              validator: (value) => value == null ? 'Please select a role' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Specialization',
                hintText: 'Cardiologist,Dermatologist ....',
                prefixIcon: const Icon(Icons.medical_services_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSaved: (value) => _specialization = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date Of Birth',
                hintText: 'MM/DD/YYYY',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateOfBirth = pickedDate;
                  });
                }
              },
              controller: TextEditingController(text: _dateOfBirth == null ? '' : "${_dateOfBirth!.month.toString().padLeft(2, '0')}/${_dateOfBirth!.day.toString().padLeft(2, '0')}/${_dateOfBirth!.year}"),
              validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
            ),
            const SizedBox(height: 30),
            CustomButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  ref.read(adminStaffViewModelProvider.notifier).registerStaff(
  _name!,
  _email!,
  _password!,
  _role,
  otherData: {
    if (_specialization != null) 'specialization': _specialization,
    if (_dateOfBirth != null) 'dateOfBirth': _dateOfBirth!.toIso8601String(),
  },
);
                }
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}