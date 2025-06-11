import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart'; 
import 'package:medsync/presentation/navigation/routes.dart'; 
import 'dart:async'; 
import 'package:shared_preferences/shared_preferences.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    _initializeAppAndNavigate();
  }

  Future<void> _initializeAppAndNavigate() async {
    
    await Future.delayed(const Duration(seconds: 2));

     if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    bool isFirstTimeUser = prefs.getBool('isFirstTimeUser') ?? true; 
   
    if (isFirstTimeUser) {
     
      await prefs.setBool('isFirstTimeUser', false);
      
      GoRouter.of(context).go(AppRoutes.intro);
    } else {
     
      bool isAuthenticated = false; 
      if (isAuthenticated) {
        GoRouter.of(context).go(AppRoutes.doctorHome);        
      } else {
        GoRouter.of(context).go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B5FF8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo
            SvgPicture.asset(
              'assets/vectors/logo.svg', // Ensure this SVG asset is correctly placed and declared in pubspec.yaml
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            // Your app name
            const Text(
              'MedSync',
              style: TextStyle(
                fontFamily: 'Quando', // Ensure this font is imported or available
                fontWeight: FontWeight.w400,
                fontSize: 54,
                height: 1.5,
                letterSpacing: -3,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            
          ],
        ),
      ),
    );
  }
}