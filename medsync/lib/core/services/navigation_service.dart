import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class NavigationService {
  static void navigateToRoleBasedHome(BuildContext context, String role) {
    switch (role) {
      case 'patient':
        context.go(AppRoutes.patientHome);
        break;
      case 'doctor':
        context.go(AppRoutes.doctorHome);
        break;
      case 'triage':
        context.go(AppRoutes.triageHome);
        break;
      case 'admin':
        context.go(AppRoutes.adminHome);
        break;
      default:
        context.go(AppRoutes.login);
    }
  }
}