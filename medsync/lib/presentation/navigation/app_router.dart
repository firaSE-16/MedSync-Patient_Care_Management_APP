import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/constants/app_constants.dart';
import 'package:medsync/core/services/shared_preferences_service.dart';
import 'package:medsync/presentation/common/widgets/profile_icon.dart';
import 'package:medsync/presentation/features/Admin/views/admin_dashboard_view.dart';
import 'package:medsync/presentation/features/Admin/views/admin_patient_appointments_view.dart';
import 'package:medsync/presentation/features/Admin/views/admin_patients_view.dart';
import 'package:medsync/presentation/features/Admin/views/admin_shell_view.dart';
import 'package:medsync/presentation/features/Admin/views/admin_staff_detail_view.dart';
import 'package:medsync/presentation/features/Admin/views/admin_staff_view.dart';
import 'package:medsync/presentation/features/Patient/views/chat_screen.dart';
import 'package:medsync/presentation/features/Patient/views/patient_appointments_screen.dart';
import 'package:medsync/presentation/features/Patient/views/patient_booking_screen.dart';
import 'package:medsync/presentation/features/Patient/views/patient_home_screen.dart';
import 'package:medsync/presentation/features/Patient/views/patient_medical_history_screen.dart';
import 'package:medsync/presentation/features/Patient/views/patient_prescriptions_screen.dart';
import 'package:medsync/presentation/features/Patient/views/patient_profile_screen.dart';
import 'package:medsync/presentation/features/Patient/views/patient_shell_view.dart';
import 'package:medsync/presentation/features/auth/views/login_view.dart';
import 'package:medsync/presentation/features/auth/views/register_view.dart';
import 'package:medsync/presentation/features/intro/views/intro_screen.dart';
import 'package:medsync/presentation/features/splash/views/splash_screen.dart';
import 'package:medsync/presentation/navigation/routes.dart';
import 'package:medsync/presentation/features/Triage/views/triage_home_screen.dart';
import 'package:medsync/presentation/features/Triage/views/triage_booking_detail_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_home_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_appointments_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_patients_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_patient_detail_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_shell_view.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_create_medical_record_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_create_prescription_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_edit_medical_record_screen.dart';
import 'package:medsync/presentation/features/doctor/views/doctor_edit_prescription_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final token = await SharedPreferencesService.getString(AppConstants.tokenKey);
      final role = await SharedPreferencesService.getString(AppConstants.roleKey);
      final isLoggedIn = token != null && role != null;
      final isSplash = state.uri.path == AppRoutes.splash;
      final isIntro = state.uri.path == AppRoutes.intro;
      final isAuthRoute = 
          state.uri.path == AppRoutes.login || 
          state.uri.path == AppRoutes.register || 
          state.uri.path == AppRoutes.resetPassword;

      // If we're on splash screen, don't redirect
      if (isSplash) return null;

      // If not logged in and trying to access protected route
      if (!isLoggedIn && !isAuthRoute && !isIntro) {
        return AppRoutes.login;
      }

      // If logged in but trying to access auth route
      if (isLoggedIn && isAuthRoute) {
        return _getRoleHome(role!);
      }

      // Special handling for admin routes
      if (isLoggedIn && role == 'admin') {
        final isAdminRoute = state.uri.path.startsWith('/admin/');
        if (!isAdminRoute) {
          return AppRoutes.adminHome;
        }
      }

      // For other protected routes, verify role access
      if (isLoggedIn) {
        final path = state.uri.path;
        if (path.startsWith('/doctor/') && role != 'doctor') {
          return _getRoleHome(role!);
        }
        if (path.startsWith('/patient/') && role != 'patient') {
          return _getRoleHome(role!);
        }
        if (path.startsWith('/triage/') && role != 'triage') {
          return _getRoleHome(role!);
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.intro,
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => Container(
          color: Colors.teal,
          child: const Center(child: Text("Reset Password Screen")),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return DoctorShellView(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.doctorHome,
            builder: (context, state) => const DoctorHomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.doctorAppointment,
            builder: (context, state) => const DoctorAppointmentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.doctorPatients,
            builder: (context, state) => const DoctorPatientsScreen(),
          ),
          GoRoute(
            path: AppRoutes.patientDetail,
            builder: (context, state) {
              final patientId = state.pathParameters['id']!;
              return DoctorPatientDetailScreen(patientId: patientId);
            },
          ),
          GoRoute(
            path: AppRoutes.doctorPrescription,
            builder: (context, state) => Container(
              color: Colors.purple.shade200,
              child: const Center(child: Text("Doctor Prescription Page")),
            ),
          ),
          GoRoute(
            path: AppRoutes.doctorHistory,
            builder: (context, state) => Container(
              color: Colors.purple.shade200,
              child: const Center(child: Text("Doctor History Page")),
            ),
          ),
          GoRoute(
            path: AppRoutes.doctorCreateMedicalRecord,
            builder: (context, state) {
              final patientId = state.uri.queryParameters['patientId'];
              return DoctorCreateMedicalRecordScreen(patientId: patientId!);
            },
          ),
          GoRoute(
            path: AppRoutes.doctorEditMedicalRecord,
            builder: (context, state) {
              final recordId = state.pathParameters['id']!;
              final patientId = state.uri.queryParameters['patientId']!;
              return DoctorEditMedicalRecordScreen(recordId: recordId, patientId: patientId);
            },
          ),
          GoRoute(
            path: AppRoutes.doctorCreatePrescription,
            builder: (context, state) {
              final patientId = state.uri.queryParameters['patientId'];
              return DoctorCreatePrescriptionScreen(patientId: patientId!);
            },
          ),
          GoRoute(
            path: AppRoutes.doctorEditPrescription,
            builder: (context, state) {
              final prescriptionId = state.pathParameters['id']!;
              return DoctorEditPrescriptionScreen(prescriptionId: prescriptionId);
            },
          ),
        ],
      ),
      ShellRoute(
      builder: (context, state, child) {
        return PatientShellView(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.patientHome,
          builder: (context, state) => const PatientHomeScreen(),
        ),
        GoRoute(path: AppRoutes.patientBooking,
          builder: (context, state) => const PatientBookingScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientAppointment,
          builder: (context, state) => const PatientAppointmentsScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientPrescription,
          builder: (context, state) => const PatientPrescriptionsScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientMedicalHistory,
          builder: (context, state) => const PatientMedicalHistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientChat,
          builder: (context, state) => const PatientDoctorsListScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientProfile,
          builder: (context, state) => const PatientProfileScreen(),
        ),
        // Keep the specific chat screen for direct navigation if needed
        GoRoute(
          path: AppRoutes.patientChatScreen, // e.g., /patient/chat/60c728e7e1c8d7001c8a1b2c
          builder: (context, state) {
            final String doctorId = state.pathParameters['id']!;
            // Replace with your actual chat screen widget that takes doctorId
            return Scaffold(
              appBar: AppBar(title: Text('Chat with Doctor ID: $doctorId')),
              body: Center(
                child: Text('Implement actual chat UI for doctor: $doctorId'),
              ),
            );
            // return PatientChatScreen(doctorId: doctorId); // Uncomment if you create this screen
          },
        ),
        // Add more patient specific routes as needed, e.g., for creating a booking
        // GoRoute(
        //   path: AppRoutes.patientBooking, // Example for a dedicated booking screen if needed
        //   builder: (context, state) => const PatientBookingScreen(),
        // ),
      ],
    ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const ProfileIcon(),
                        onPressed: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await SharedPreferencesService.clear();
                                      if (context.mounted) {
                                        context.go(AppRoutes.login);
                                      }
                                    },
                                    child: const Text('Logout'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: child,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7A6CF0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: BottomNavigationBar(
                currentIndex: 0, // Assuming a default for Triage for now
                onTap: (index) { /* handle navigation if needed */ },
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 28,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    activeIcon: Icon(Icons.calendar_today),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_outline),
                    activeIcon: Icon(Icons.people),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    activeIcon: Icon(Icons.settings),
                    label: '',
                  ),
                ],
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.triageHome,
            builder: (context, state) => const TriageHomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.triageBookingDetail,
            builder: (context, state) {
              final bookingId = state.pathParameters['id']!;
              return TriageBookingDetailScreen(bookingId: bookingId);
            },
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AdminShellView(child: child);
        },
        routes: [
          GoRoute(
          path: AppRoutes.adminHome, // This will now be the Admin Patients View
          builder: (context, state) => const AdminPatientsView(),
        ),
        GoRoute(
          path: AppRoutes.adminStaff,
          builder: (context, state) => const AdminStaffView(),
        ),
        GoRoute(
          path: AppRoutes.adminDashboard,
          builder: (context, state) => const AdminDashboardView(),
        ),
        GoRoute(
          path: AppRoutes.adminPatientAppointments,
          builder: (context, state) => const AdminPatientAppointmentsView(),
        ),
        GoRoute(
          path: AppRoutes.adminStaffDetail,
          builder: (context, state) => AdminStaffDetailView(
            staffId: state.pathParameters['id']!,
          ),
        ),
        ],
      ),
    ],
  );
});

String _getRoleHome(String role) {
  switch (role) {
    case 'admin':
      return AppRoutes.adminHome;
    case 'doctor':
      return AppRoutes.doctorHome;
    case 'triage':
      return AppRoutes.triageHome;
    case 'patient':
    default:
      return AppRoutes.patientHome;
  }
}