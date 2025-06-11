import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/presentation/common/widgets/profile_icon.dart';
import 'package:medsync/presentation/navigation/routes.dart';
import 'package:medsync/core/services/shared_preferences_service.dart';

class AdminShellView extends StatefulWidget {
  final Widget child;

  const AdminShellView({super.key, required this.child});

  @override
  State<AdminShellView> createState() => _AdminShellViewState();
}

class _AdminShellViewState extends State<AdminShellView> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/admin/home');
        break;
      case 1:
        context.go('/admin/staff');
        break;
      case 2:
        context.go('/admin/dashboard');
        break;
      case 3:
        context.go('/admin/patient-appointments');
        break;
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
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
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _showLogoutDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: widget.child,
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
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
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
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}