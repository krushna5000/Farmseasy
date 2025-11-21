import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';
import '../utils/animated_navigator.dart';
import 'mobile_number_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _logoController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late AnimationController _textController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late AnimationController _buttonController;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Button animations
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    // Start animations sequentially
    _logoController.forward().then((_) {
      _textController.forward().then((_) {
        _buttonController.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌾 App Logo with animation
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: Image.asset(
                      'assets/icons/final_logo.png',
                      width: 140,
                      height: 140,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 👨‍🌾 Illustration with animation
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: Image.asset(
                      'assets/illustrations/farmer_illustration.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 🏡 Welcome Text with animation
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      "Welcome to FarmEasy 🌾",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 💬 Subtitle with animation
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      "Empowering farmers with smart technology",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppTheme.lightGray,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // 🚀 Get Started Button with animation
                FadeTransition(
                  opacity: _buttonFadeAnimation,
                  child: GestureDetector(
                    onTapDown: (_) => setState(() => _isPressed = true),
                    onTapUp: (_) {
                      setState(() => _isPressed = false);
                      Navigator.pushReplacement(
                        context,
                        animatedRoute(const MobileNumberScreen()),
                      );
                    },
                    onTapCancel: () => setState(() => _isPressed = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _isPressed
                            ? AppTheme.primaryGreen.withOpacity(0.85)
                            : AppTheme.primaryGreen,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: GoogleFonts.poppins(
                            color: AppTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
