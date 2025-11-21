import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: _isPressed
                ? [
                    AppTheme.accentGreen.withOpacity(0.85),
                    AppTheme.primaryGreen.withOpacity(0.85)
                  ]
                : [
                    AppTheme.primaryGreen,
                    AppTheme.accentGreen,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.4,
                  ),
                )
              : Text(
                  widget.text,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
