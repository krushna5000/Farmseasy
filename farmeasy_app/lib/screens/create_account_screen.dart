import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'otp_screen.dart';
import '../theme/theme.dart';
import '../utils/animated_navigator.dart';

class CreateAccountScreen extends StatefulWidget {
  final String mobile;
  const CreateAccountScreen({super.key, required this.mobile});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with TickerProviderStateMixin {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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

  Future<void> createAccount() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    if (fullName.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill in all fields"),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await AuthService.sendRegisterOtp(widget.mobile, fullName);
      Navigator.push(
        context,
        animatedRoute(OtpScreen(mobile: widget.mobile, isLogin: false)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
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
                    child: const Icon(Icons.person_add, color: AppTheme.primaryGreen, size: 80),
                  ),
                ),
                const SizedBox(height: 20),

                // Text with animation
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      "Create Account",
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
                      "Enter your details to get started",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Full Name Input Card with animation
                FadeTransition(
                  opacity: _inputFadeAnimation,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person, color: AppTheme.primaryGreen),
                          labelText: "Full Name",
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Email Input Card with animation
                FadeTransition(
                  opacity: _inputFadeAnimation,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email, color: AppTheme.primaryGreen),
                          labelText: "Email",
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
                      onPressed: isLoading ? null : createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Create Account",
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
