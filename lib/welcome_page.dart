import 'package:flutter/material.dart';
import 'order_selection_page.dart';
import 'utils/page_transitions.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _hoverController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Hover animation controller (up and down motion)
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Hover animation (smooth up and down)
    _hoverAnimation = Tween<double>(
      begin: -15.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    // Start fade-in animation after a brief delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            SlidePageRoute(
              child: const OrderSelectionPage(),
              direction: SlideDirection.leftToRight,
            ),
          );
        },
        child: Stack(
          children: [
            // Background gradient image (1.png)
            SizedBox.expand(
              child: Image.asset(
                "assets/images/1.png",
                fit: BoxFit.cover,
              ),
            ),
            // Foreground image (11.png) with fade-in and hover animations
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_fadeController, _hoverController]),
                builder: (context, child) {
                  // Slide up animation: starts from below (positive offset) and moves to final position
                  final slideUpOffset = (1.0 - _fadeAnimation.value) * 80.0; // Start 80px below, move up as it fades in
                  return Transform.translate(
                    offset: Offset(0, slideUpOffset + _hoverAnimation.value - 50), // Slide up + hover + top offset
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        "assets/images/11.png",
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width * 0.5, // Smaller size (50% instead of 80%)
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading 11.png: $error');
                          return Container(
                            color: Colors.red.withOpacity(0.3),
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text('Error loading 11.png: $error'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

