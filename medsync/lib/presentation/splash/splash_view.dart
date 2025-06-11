import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/services/shared_preferences_service.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await SharedPreferencesService.getString('token');
    final role = await SharedPreferencesService.getString('role');

    if (token == null || role == null) {
      context.go(AppRoutes.intro);
    } else {
      switch (role) {
        case 'admin':
          context.go(AppRoutes.adminDashboard);
          break;
        case 'doctor':
          context.go(AppRoutes.doctorHome);
          break;
        case 'triage':
          context.go(AppRoutes.triageHome);
          break;
        case 'patient':
          context.go(AppRoutes.patientHome);
          break;
        default:
          context.go(AppRoutes.intro);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
} 