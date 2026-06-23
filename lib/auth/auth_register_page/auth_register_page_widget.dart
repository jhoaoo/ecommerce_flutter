import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/index.dart';
import '/auth/auth_verification_page/auth_verification_page_widget.dart';

// Re-use constants from login page (or define here for independence)
const _kBg = Color(0xFF0A0A0F);
const _kCard = Color(0xFF13131A);
const _kAccent = Color(0xFFF5C842);
const _kBorder = Color(0xFF2A2A35);
const _kMuted = Color(0xFF6B6B7A);

class AuthRegisterPageWidget extends StatefulWidget {
  const AuthRegisterPageWidget({super.key});

  static String routeName = 'auth_register_page';
  static String routePath = '/authRegisterPage';

  @override
  State<AuthRegisterPageWidget> createState() => _AuthRegisterPageWidgetState();
}

class _AuthRegisterPageWidgetState extends State<AuthRegisterPageWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String? _errorMessage;
  bool _shaking = false;

  int _passwordStrength = 0; // 0-4

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final p = _passwordController.text;
    int strength = 0;
    if (p.length >= 8) strength++;
    if (p.contains(RegExp(r'[A-Z]'))) strength++;
    if (p.contains(RegExp(r'[0-9]'))) strength++;
    if (p.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength++;
    setState(() => _passwordStrength = strength);
  }

  void _triggerShake() {
    setState(() => _shaking = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _shaking = false);
    });
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _triggerShake();
      return;
    }
    if (!_acceptTerms) {
      setState(() => _errorMessage = 'Debes aceptar los terminos y condiciones.');
      _triggerShake();
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      setState(() => _errorMessage = 'Las contrasenas no coinciden.');
      _triggerShake();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await authManager.createAccountWithEmail(
        context,
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      if (user != null) {
        await authManager.sendEmailVerification();
        // Update display name in Firestore
        await updateUserDocument(
          displayName: _nameController.text.trim(),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AuthVerificationPageWidget.routePath,
          (_) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'No se pudo crear la cuenta. Intentalo de nuevo.');
        _triggerShake();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoading = true);
    try {
      final user = await authManager.signInWithGoogle(context);
      if (!mounted) return;
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Bottom accent glow
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x101DBFB0),
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
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: _kCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kBorder),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 16,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 40),

                  Text(
                    'Crea tu\ncuenta',
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
                    'Completa los datos para empezar',
                    style: GoogleFonts.dmSans(
                      fontSize: 15, color: _kMuted, fontWeight: FontWeight.w400,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                  const SizedBox(height: 36),

                  // Form
                  AnimatedSlide(
                    offset: _shaking ? const Offset(0.02, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 80),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _AuthField(
                            controller: _nameController,
                            label: 'Nombre completo',
                            hint: 'Tu nombre',
                            icon: Icons.person_outline_rounded,
                            validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu nombre' : null,
                          ).animate().fadeIn(delay: 280.ms, duration: 400.ms).slideX(begin: -0.05, end: 0),

                          const SizedBox(height: 16),

                          _AuthField(
                            controller: _emailController,
                            label: 'Correo electronico',
                            hint: 'tu@email.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Ingresa tu correo';
                              if (!v.contains('@')) return 'Correo invalido';
                              return null;
                            },
                          ).animate().fadeIn(delay: 340.ms, duration: 400.ms).slideX(begin: -0.05, end: 0),

                          const SizedBox(height: 16),

                          _AuthField(
                            controller: _passwordController,
                            label: 'Contrasena',
                            hint: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: !_passwordVisible,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                              child: Icon(
                                _passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: _kMuted, size: 20,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Ingresa una contrasena';
                              if (v.length < 6) return 'Minimo 6 caracteres';
                              return null;
                            },
                          ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideX(begin: -0.05, end: 0),

                          const SizedBox(height: 10),

                          // Password strength bar
                          if (_passwordController.text.isNotEmpty)
                            _PasswordStrengthBar(strength: _passwordStrength)
                                .animate()
                                .fadeIn(duration: 300.ms),

                          const SizedBox(height: 16),

                          _AuthField(
                            controller: _confirmController,
                            label: 'Confirmar contrasena',
                            hint: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: !_confirmVisible,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() => _confirmVisible = !_confirmVisible),
                              child: Icon(
                                _confirmVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: _kMuted, size: 20,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Confirma tu contrasena';
                              if (v != _passwordController.text) return 'Las contrasenas no coinciden';
                              return null;
                            },
                          ).animate().fadeIn(delay: 460.ms, duration: 400.ms).slideX(begin: -0.05, end: 0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Terms checkbox
                  GestureDetector(
                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: _acceptTerms ? _kAccent : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _acceptTerms ? _kAccent : _kBorder,
                              width: 1.5,
                            ),
                          ),
                          child: _acceptTerms
                              ? const Icon(Icons.check, color: _kBg, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Acepto los ',
                              style: GoogleFonts.dmSans(fontSize: 13, color: _kMuted),
                              children: [
                                TextSpan(
                                  text: 'Terminos y Condiciones',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 13, color: _kAccent, fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: ' y la ',
                                  style: GoogleFonts.dmSans(fontSize: 13, color: _kMuted),
                                ),
                                TextSpan(
                                  text: 'Politica de Privacidad',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 13, color: _kAccent, fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 520.ms, duration: 400.ms),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
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
                                fontSize: 13, color: Colors.red.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().shake(hz: 3, offset: const Offset(4, 0)),
                  ],

                  const SizedBox(height: 24),

                  // Register button
                  _LoadingButton(
                    label: 'Crear cuenta',
                    isLoading: _isLoading,
                    onTap: _handleRegister,
                  ).animate().fadeIn(delay: 580.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: _kBorder, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'o registrate con',
                          style: GoogleFonts.dmSans(fontSize: 13, color: _kMuted),
                        ),
                      ),
                      Expanded(child: Divider(color: _kBorder, thickness: 1)),
                    ],
                  ).animate().fadeIn(delay: 650.ms, duration: 400.ms),

                  const SizedBox(height: 20),

                  // Google button
                  _SocialButton(
                    label: 'Continuar con Google',
                    icon: _GoogleIcon(),
                    onTap: _handleGoogleRegister,
                    fullWidth: true,
                  ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

                  const SizedBox(height: 28),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        AuthLoginPageWidget.routePath,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Ya tienes cuenta? ',
                          style: GoogleFonts.dmSans(fontSize: 14, color: _kMuted),
                          children: [
                            TextSpan(
                              text: 'Inicia sesion',
                              style: GoogleFonts.dmSans(
                                fontSize: 14, color: _kAccent, fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 760.ms, duration: 400.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Password strength bar ─────────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  final int strength; // 0-4

  const _PasswordStrengthBar({required this.strength});

  Color get _color {
    if (strength <= 1) return Colors.red.shade400;
    if (strength == 2) return Colors.orange.shade400;
    if (strength == 3) return Colors.yellow.shade600;
    return Colors.green.shade400;
  }

  String get _label {
    if (strength <= 1) return 'Debil';
    if (strength == 2) return 'Regular';
    if (strength == 3) return 'Buena';
    return 'Muy fuerte';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                height: 3,
                decoration: BoxDecoration(
                  color: i < strength ? _color : _kBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 5),
        Text(
          'Seguridad: $_label',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: _color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Shared widgets (same as login, kept here for file independence) ────────

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
            fontSize: 13, fontWeight: FontWeight.w600,
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
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.dmSans(fontSize: 15, color: _kMuted),
                prefixIcon: Icon(widget.icon, color: _kMuted, size: 19),
                suffixIcon: widget.suffixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: widget.suffixIcon,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                errorStyle: GoogleFonts.dmSans(fontSize: 12, color: Colors.red.shade400),
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
  const _LoadingButton({required this.label, required this.isLoading, required this.onTap});

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
          width: double.infinity, height: 56,
          decoration: BoxDecoration(
            color: _kAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: _kAccent.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: _kBg),
                )
              : Text(
                  widget.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: _kBg, letterSpacing: 0.2,
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
  final bool fullWidth;
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.fullWidth = false,
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
          width: widget.fullWidth ? double.infinity : null,
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
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
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
      width: 20, height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    const c = Offset(10, 10);
    const r = 9.0;
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -0.35, 1.22, false, paint);
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 0.87, 1.22, false, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 2.09, 0.7, false, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), 2.79, 0.58, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}