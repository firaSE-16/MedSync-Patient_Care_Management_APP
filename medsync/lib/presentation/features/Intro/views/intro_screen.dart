import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medsync/presentation/navigation/routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/intro1.png', // Ensure these paths are correct
      'title': 'Your Health, Streamlined and Simple', // Updated title for the first screen
      'description': 'Say goodbye to missed appointments and lost prescriptions. Medsync keeps you connected to your doctor, anytime, from anywhere.' // Updated description
    },
    {
      'image': 'assets/images/intro2.png',
      'title': 'Stay Connected with Doctors', // Original title, but could be adjusted
      'description': 'Easily chat with your doctor and get updates on your health status anytime.'
    },
    {
      'image': 'assets/images/intro3.png',
      'title': 'Track Appointments', // Original title, but could be adjusted
      'description': 'Manage all your appointments in one place with timely reminders.'
    },
    // You might need to add another page for "Your Health in One App" if it's a separate screen
    // or combine the content if the image is just a generic intro layout.
    // For now, I'm adapting the first page's content to match the image.
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // On the last page, navigate to login
      GoRouter.of(context).go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Use Stack to place the image and the content overlay
        children: [
          // Background Image (stretched to fill)
          // Make sure intro1.png is a suitable background image or placeholder
          Positioned.fill(
            child: Image.asset(
              _pages[_currentIndex]['image']!, // Use the current page's image
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF6B5FF8),      // Solid purple at the bottom
                    Color(0xFF6B5FF8),      // Solid purple extending upwards
                    Color(0x036B5FF8),      // Almost transparent purple at the top (matches original)
                  ],
                  stops: [0.0, 0.3, 1.0], // Controls gradient distribution
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemCount: _pages.length,
                    itemBuilder: (_, index) {
                      final page = _pages[index];
                      // For the first page, use the specific content from the image
                      // For other pages, you can either create more image-specific content
                      // or use the generic structure you had.
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end, // Align content to the bottom
                        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                        children: [
                          // Page Indicators (Dots)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (dotIndex) => buildDot(dotIndex, context),
                            ),
                          ),
                          const SizedBox(height: 20), // Spacing between dots and title

                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding
                            child: Text(
                              page['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                height: 1.2, // Adjust line height for better appearance
                                letterSpacing: 0.005,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16), // Spacing between title and description

                          // Description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding
                            child: Text(
                              page['description']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.5, // Adjust line height
                                letterSpacing: 0.005,
                                color: Color.fromARGB(255, 201, 198, 240),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40), // Spacing before the button

                          // Continue Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.5),
                            child: SizedBox(
                              width: double.infinity, // Make button fill width
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // Solid white background
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0, // No shadow
                                ),
                                child: Text(
                                  _currentIndex == _pages.length - 1 ? 'Get Started' : 'Continue',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Color(0xFF6B5FF8), // Text color same as primary purple
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // "Skip to login" button
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 20.0), // Adjust padding as needed
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TextButton(
                      onPressed: () => GoRouter.of(context).go(AppRoutes.login),
                      child: const Text(
                        'Skip to login', 
                        style: TextStyle(
                          fontFamily: 'Proxima Nova Soft', // Ensure font is loaded
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                          const SizedBox(height: 40), // Bottom padding
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentIndex == index ? 10 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentIndex == index ? Colors.white : Colors.white54,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}