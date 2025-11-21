import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/theme.dart';
import 'home_screen.dart';
import '../utils/animated_navigator.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  final bool isLogin;
  const OtpScreen({super.key, required this.mobile, required this.isLogin});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with TickerProviderStateMixin {
  final TextEditingController otpController = TextEditingController();
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
  late AnimationController _resendController;
  late Animation<double> _resendFadeAnimation;

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

    // Resend button animations
    _resendController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _resendFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resendController, curve: Curves.easeOut),
    );

    // Start animations sequentially
    _iconController.forward().then((_) {
      _textController.forward().then((_) {
        _inputController.forward().then((_) {
          _buttonController.forward().then((_) {
            _resendController.forward();
          });
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
    _resendController.dispose();
    super.dispose();
  }

  Future<void> verifyOtpAction() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Enter a valid 6-digit OTP"),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = widget.isLogin ? await AuthService.verifyLoginOtp(widget.mobile, otp) : await AuthService.verifyRegisterOtp(widget.mobile, otp);
      // result is Map<String, dynamic> with "token", "user", "message"
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"] ?? "OTP verified successfully"),
          backgroundColor: Colors.green.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pushReplacement(
        context,
        animatedRoute(const HomeScreen()),
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

  Future<void> resendOtp() async {
    try {
      final sent = widget.isLogin
          ? await AuthService.sendLoginOtp(widget.mobile)
          : await AuthService.sendRegisterOtp(widget.mobile, ""); // For resend, fullName not needed for login, but for register we might need to handle differently
      if (sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("OTP resent successfully"),
            backgroundColor: AppTheme.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error resending OTP: $e"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔒 Icon with animation
              FadeTransition(
                opacity: _iconFadeAnimation,
                child: ScaleTransition(
                  scale: _iconScaleAnimation,
                  child: const Icon(
                    Icons.lock_open_rounded,
                    color: AppTheme.primaryGreen,
                    size: 70,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 📱 Info Text with animation
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    "Enter the 6-digit OTP sent to",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppTheme.darkGray.withOpacity(0.8),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    widget.mobile,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // 🔢 OTP Input with animation
              FadeTransition(
                opacity: _inputFadeAnimation,
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: "Enter OTP",
                    prefixIcon: const Icon(Icons.pin, color: AppTheme.primaryGreen),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Verify Button with animation
              FadeTransition(
                opacity: _buttonFadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verifyOtpAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text("Verify OTP"),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 🔁 Resend OTP with animation
              FadeTransition(
                opacity: _resendFadeAnimation,
                child: TextButton(
                  onPressed: resendOtp,
                  child: const Text("Resend OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
