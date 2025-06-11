import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/core/services/navigation_service.dart';
import 'package:medsync/core/utils/app_validators.dart';
import 'package:medsync/core/widgets/loading_indicator.dart';
import 'package:medsync/presentation/common/styles/app_text_styles.dart';
import 'package:medsync/presentation/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:medsync/presentation/navigation/routes.dart';

// Assuming you have a CustomButton widget defined like this, or you can replace it with ElevatedButton
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.selected}) ?? Theme.of(context).colorScheme.primary,
        foregroundColor: textColor ?? Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({MaterialState.selected}) ?? Theme.of(context).colorScheme.onPrimary,
        minimumSize: const Size.fromHeight(50), // Make button full width and a bit taller
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(text),
    );
  }
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // GlobalKeys for each form section
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emergencyContactNameController = TextEditingController();
  final TextEditingController _emergencyContactNumberController = TextEditingController();

  // Selected values for dropdowns
  String? _selectedGender;
  String? _selectedBloodGroup;

  // Dropdown options
  final List<String> _genders = ['male', 'female', 'other'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactNumberController.dispose();
    super.dispose();
  }

  void _nextPage() {
    bool isValid = false;
    if (_currentPage == 0) {
      isValid = _formKey1.currentState!.validate();
    } else if (_currentPage == 1) {
      isValid = _formKey2.currentState!.validate();
    }

    if (isValid) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _register() {
    if (_formKey3.currentState!.validate()) {
      ref.read(authViewModelProvider.notifier).registerPatient(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        dateOfBirth: _dobController.text,
        gender: _selectedGender!,
        bloodGroup: _selectedBloodGroup!,
        emergencyContactName: _emergencyContactNameController.text,
        emergencyContactNumber: _emergencyContactNumberController.text,
      ).then((_) {
        final user = ref.read(authViewModelProvider).value;
        if (user != null) {
          NavigationService.navigateToRoleBasedHome(context, user.role);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator (dots at the top)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Theme.of(context).colorScheme.primary // Active dot color
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.3), // Inactive dot color
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swiping
                children: [
                  _buildFirstStep(context, authState),
                  _buildSecondStep(context, authState),
                  _buildThirdStep(context, authState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstStep(BuildContext context, AsyncValue<dynamic> authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Start Your Health Journey',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Let\'s tailor your experience with a few steps.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            // Your Name
            Text(
              'Your Name',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'E.g., Alex Johnson',
                prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              validator: AppValidators.validateName,
            ),
            const SizedBox(height: 16),

            // Date Of Birth
            Text(
              'Date Of Birth',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _dobController,
              keyboardType: TextInputType.datetime,
              readOnly: true, // Make it read-only to open date picker
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dobController.text = "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'MM/DD/YYYY',
                prefixIcon: Icon(Icons.calendar_today_outlined, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              validator: AppValidators.validateDateOfBirth,
            ),
            const SizedBox(height: 16),

            // Your Gender
            Text(
              'Your Gender',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                hintText: 'How do you identify?',
                prefixIcon: Icon(Icons.people_outline, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              validator: AppValidators.validateGender,
            ),
            const SizedBox(height: 16),

            // Your Age
            Text(
              'Your Age',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'E.g., 18',
                prefixIcon: Icon(Icons.cake_outlined, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              validator: AppValidators.validateAge,
            ),
            const SizedBox(height: 40),

            CustomButton(
              text: 'Next',
              onPressed: _nextPage,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text(
                'Do this later',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondStep(BuildContext context, AsyncValue<dynamic> authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Share a Bit More',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Let\'s tailor your experience with a few steps.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            // Blood Group
            Text(
              'Blood Group',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedBloodGroup,
              decoration: InputDecoration(
                hintText: 'E.g., A+ or B-',
                prefixIcon: Icon(Icons.bloodtype_outlined, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              items: _bloodGroups.map((bloodGroup) {
                return DropdownMenuItem(
                  value: bloodGroup,
                  child: Text(bloodGroup),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodGroup = value;
                });
              },
              validator: AppValidators.validateBloodGroup,
            ),
            const SizedBox(height: 16),

            // Emergency Contact Name
            Text(
              'Emergency Contact Name',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emergencyContactNameController,
              decoration: InputDecoration(
                hintText: 'E.g., Alex Johnson',
                prefixIcon: Icon(Icons.group_outlined, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              validator: AppValidators.validateName,
            ),
            const SizedBox(height: 16),

            // Emergency Contact Number
            Text(
              'Emergency Contact Number',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emergencyContactNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '0979....',
                prefixIcon: Icon(Icons.phone_outlined, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              
            ),
            const SizedBox(height: 40),

            CustomButton(
              text: 'Next',
              onPressed: _nextPage,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text(
                'Do this later',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdStep(BuildContext context, AsyncValue<dynamic> authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'You\'re Ready to Connect',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Let\'s tailor your experience with a few steps.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            // Email
            Text(
              'Email',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'E.g., you@example.com',
                prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              validator: AppValidators.validateEmail,
            ),
            const SizedBox(height: 16),

            // Password
            Text(
              'Password',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Your password',
                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              validator: AppValidators.validatePassword,
            ),
            const SizedBox(height: 16),

            // Confirm Password
            Text(
              'Confirm Password',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm your password here',
                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              validator: (value) => AppValidators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 40),

            authState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
              text: 'Register',
              onPressed: _register,
            ),
            if (authState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  authState.error.toString(),
                  style: AppTextStyles.error,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text(
                'Already have an account? Login',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}