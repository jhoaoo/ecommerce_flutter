import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/auth/auth_verification_page/auth_verification_page_widget.dart';
import '/index.dart';

// ─── Constants ─────────────────────────────────────────────────────────────
const _kBg = Color(0xFF0A0A0F);
const _kCard = Color(0xFF13131A);
const _kAccent = Color(0xFFF5C842);
const _kBorder = Color(0xFF2A2A35);
const _kMuted = Color(0xFF6B6B7A);

class AuthLoginPageWidget extends StatefulWidget {
  const AuthLoginPageWidget({super.key});

  static String routeName = 'auth_login_page';
  static String routePath = '/authLoginPage';

  @override
  State<AuthLoginPageWidget> createState() => _AuthLoginPageWidgetState();
}

class _AuthLoginPageWidgetState extends State<AuthLoginPageWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  // For shake animation on error
  final _shakeKey = GlobalKey();
  bool _shaking = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _triggerShake();
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await authManager.signInWithEmail(
        context,
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      if (user != null) {
        if (!user.emailVerified) {
          Navigator.pushNamed(context, AuthVerificationPageWidget.routePath);
        } else {
          // Navigate to home — adjust route as needed
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Credenciales incorrectas. Inténtalo de nuevo.');
        _triggerShake();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final user = await authManager.signInWithGoogle(context);
      if (!mounted) return;
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Error al iniciar con Google.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _triggerShake() {
    setState(() => _shaking = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _shaking = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Top accent glow
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x18F5C842),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _kCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kBorder),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 40),

                  // Heading
                  Text(
                    'Bienvenido\nde vuelta',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: -0.8,
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    'Ingresa tus datos para continuar',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: _kMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                  const SizedBox(height: 40),

                  // Form with shake
                  AnimatedSlide(
                    offset: _shaking ? const Offset(0.02, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 80),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email field
                          _AuthField(
                            controller: _emailController,
                            label: 'Correo electrónico',
                            hint: 'tu@email.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Ingresa tu correo';
                              if (!v.contains('@')) return 'Correo inválido';
                              return null;
                            },
                          ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: -0.05, end: 0),

                          const SizedBox(height: 16),

                          // Password field
                          _AuthField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            hint: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: !_passwordVisible,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                              child: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _kMuted,
                                size: 20,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                              if (v.length < 6) return 'Mínimo 6 caracteres';
                              return null;
                            },
                          ).animate().fadeIn(delay: 380.ms, duration: 400.ms).slideX(begin: -0.05, end: 0),
                        ],
                      ),
                    ),
                  ),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showForgotPassword(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: _kAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 450.ms, duration: 400.ms),

                  // Error message
                  if (_errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: Colors.red.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().shake(hz: 3, offset: const Offset(4, 0)),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 8),

                  // Login button
                  _LoadingButton(
                    label: 'Iniciar sesión',
                    isLoading: _isLoading,
                    onTap: _handleLogin,
                  ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: _kBorder, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'o continúa con',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: _kMuted,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: _kBorder, thickness: 1)),
                    ],
                  ).animate().fadeIn(delay: 580.ms, duration: 400.ms),

                  const SizedBox(height: 20),

                  // Social buttons
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          label: 'Google',
                          icon: _GoogleIcon(),
                          onTap: _handleGoogleLogin,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SocialButton(
                          label: 'Apple',
                          icon: const Icon(Icons.apple, color: Colors.white, size: 20),
                          onTap: () => authManager.signInWithApple(context),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 650.ms, duration: 400.ms),

                  const SizedBox(height: 32),

                  // Register link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        AuthRegisterPageWidget.routePath,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: '¿No tienes cuenta? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: _kMuted,
                          ),
                          children: [
                            TextSpan(
                              text: 'Regístrate',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: _kAccent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 720.ms, duration: 400.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPassword(BuildContext context) {
    final emailCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ForgotPasswordSheet(
        controller: emailCtrl,
        onSend: () async {
          if (emailCtrl.text.isEmpty) return;
          await authManager.resetPassword(
            email: emailCtrl.text.trim(),
            context: context,
          );
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
}

// ─── Shared auth components ─────────────────────────────────────────────────

class _AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<_AuthField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _focused ? _kAccent.withOpacity(0.7) : _kBorder,
                width: _focused ? 1.5 : 1,
              ),
              boxShadow: _focused
                  ? [BoxShadow(color: _kAccent.withOpacity(0.08), blurRadius: 12, spreadRadius: 1)]
                  : [],
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: _kMuted,
                ),
                prefixIcon: Icon(widget.icon, color: _kMuted, size: 19),
                suffixIcon: widget.suffixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: widget.suffixIcon,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                errorStyle: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;
  const _LoadingButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<_LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<_LoadingButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!widget.isLoading) widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: _kAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _kAccent.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: _kBg,
                  ),
                )
              : Text(
                  widget.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _kBg,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _kCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Simplified G icon using colored arcs
    const center = Offset(10, 10);
    const radius = 9.0;
    // Blue arc
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.35,
      1.22,
      false,
      paint..style = PaintingStyle.stroke..strokeWidth = 3,
    );
    // Red arc
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.87,
      1.22,
      false,
      paint,
    );
    // Yellow arc
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.09,
      0.7,
      false,
      paint,
    );
    // Green arc
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.79,
      0.58,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Forgot Password Bottom Sheet ──────────────────────────────────────────

class _ForgotPasswordSheet extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function() onSend;
  const _ForgotPasswordSheet({required this.controller, required this.onSend});

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  bool _sent = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: _sent ? _SuccessContent() : _FormContent(
          controller: widget.controller,
          loading: _loading,
          onSend: () async {
            setState(() => _loading = true);
            await widget.onSend();
            if (mounted) setState(() { _loading = false; _sent = true; });
          },
        ),
      ),
    );
  }
}

class _FormContent extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final VoidCallback onSend;
  const _FormContent({required this.controller, required this.loading, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle
        Center(
          child: Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: _kBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Recuperar contraseña',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Te enviaremos un enlace a tu correo para restablecer tu contraseña.',
          style: GoogleFonts.dmSans(fontSize: 14, color: _kMuted, height: 1.5),
        ),
        const SizedBox(height: 24),
        _AuthField(
          controller: controller,
          label: 'Correo electrónico',
          hint: 'tu@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        _LoadingButton(label: 'Enviar enlace', isLoading: loading, onTap: onSend),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SuccessContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: _kAccent.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mark_email_read_outlined, color: _kAccent, size: 32),
        )
            .animate()
            .scale(begin: const Offset(0.5, 0.5), duration: 400.ms, curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text(
          '¡Correo enviado!',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Revisa tu bandeja de entrada y sigue las instrucciones.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(fontSize: 14, color: _kMuted, height: 1.5),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: _kBorder,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              'Entendido',
              style: GoogleFonts.dmSans(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}