import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'create_account_screen.dart';
import 'otp_screen.dart';
import '../theme/theme.dart';
import '../utils/animated_navigator.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen>
    with TickerProviderStateMixin {
  final TextEditingController mobileController = TextEditingController();
  bool isLoading = false;
  late AnimationController _iconController;
  late Animation<double> _iconFadeAnimation;
  late Animation<double> _iconScaleAnimation;
  late AnimationController _textController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late AnimationController _inputController;
  late Animation<double> _inputFadeAnimation;
  late AnimationController _buttonController;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Icon animations
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _iconFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOut),
    );
    _iconScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Input animations
    _inputController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _inputFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _inputController, curve: Curves.easeOut),
    );

    // Button animations
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    // Start animations sequentially
    _iconController.forward().then((_) {
      _textController.forward().then((_) {
        _inputController.forward().then((_) {
          _buttonController.forward();
        });
      });
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _inputController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> continueAction() async {
    final mobile = mobileController.text.trim();
    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a valid 10-digit mobile number"),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      // Try to send OTP without fullName to check if user exists
      final sent = await AuthService.sendOtp(mobile);
      if (sent) {
        // User exists, go directly to OTP screen
        Navigator.push(
          context,
          animatedRoute(OtpScreen(mobile: mobile)),
        );
      }
    } catch (e) {
      // Check if error is due to new user requiring full name
      if (e.toString().contains("Full name required for new user")) {
        // New user, go to create account screen
        Navigator.push(
          context,
          animatedRoute(CreateAccountScreen(mobile: mobile)),
        );
      } else {
        // Other error, show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBeige,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Icon with animation
                FadeTransition(
                  opacity: _iconFadeAnimation,
                  child: ScaleTransition(
                    scale: _iconScaleAnimation,
                    child: const Icon(Icons.phone_iphone, color: AppTheme.primaryGreen, size: 80),
                  ),
                ),
                const SizedBox(height: 20),

                // Text with animation
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      "Login using your mobile number",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Input Card with animation
                FadeTransition(
                  opacity: _inputFadeAnimation,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.phone, color: AppTheme.primaryGreen),
                          labelText: "Mobile Number",
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Button with animation
                FadeTransition(
                  opacity: _buttonFadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : continueAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Continue",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
