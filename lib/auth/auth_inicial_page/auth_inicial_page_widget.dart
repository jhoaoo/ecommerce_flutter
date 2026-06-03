import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/index.dart';

class AuthInicialPageWidget extends StatefulWidget {
  const AuthInicialPageWidget({super.key});

  static String routeName = 'auth_inicial_page';
  static String routePath = '/authInicialPage';

  @override
  State<AuthInicialPageWidget> createState() => _AuthInicialPageWidgetState();
}

class _AuthInicialPageWidgetState extends State<AuthInicialPageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: _BlobPainter(_bgController.value),
              );
            },
          ),

          // Noise overlay texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Noise_salt_and_pepper.png/240px-Noise_salt_and_pepper.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // Logo mark
                  _LogoMark()
                      .animate()
                      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                      .slideY(begin: -0.3, end: 0),

                  const Spacer(),

                  // Main heading
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descubre\nlo mejor,',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 700.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 4),
                      Text(
                        'sin salir de casa.',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 52,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFFF5C842),
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 350.ms, duration: 700.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Miles de productos. Entrega rápida.\nTu tienda favorita en un solo lugar.',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.5),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 600.ms),

                  const SizedBox(height: 48),

                  // Buttons
                  _PrimaryButton(
                    label: 'Crear cuenta',
                    onTap: () => Navigator.pushNamed(
                      context,
                      AuthRegisterPageWidget.routePath,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 650.ms, duration: 500.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 14),

                  _SecondaryButton(
                    label: 'Iniciar sesión',
                    onTap: () => Navigator.pushNamed(
                      context,
                      AuthLoginPageWidget.routePath,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 750.ms, duration: 500.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 40),

                  // Trust badge row
                  _TrustRow()
                      .animate()
                      .fadeIn(delay: 900.ms, duration: 600.ms),

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

// ─── Logo ──────────────────────────────────────────────────────────────────

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF5C842),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.shopping_bag_rounded, color: Colors.black, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          'shopflow',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// ─── Buttons ───────────────────────────────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5C842),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF5C842).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0A0A0F),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
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
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Trust row ─────────────────────────────────────────────────────────────

class _TrustRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TrustItem(icon: Icons.verified_rounded, label: 'Pagos seguros'),
        Container(
          width: 1,
          height: 28,
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
        _TrustItem(icon: Icons.local_shipping_rounded, label: 'Envío rápido'),
        Container(
          width: 1,
          height: 28,
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
        _TrustItem(icon: Icons.replay_rounded, label: 'Devoluciones'),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFF5C842), size: 14),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: Colors.white.withOpacity(0.45),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Background blob painter ───────────────────────────────────────────────

class _BlobPainter extends CustomPainter {
  final double t;
  _BlobPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blob 1 – amber/gold
    paint.color = const Color(0xFFF5C842).withOpacity(0.12);
    final cx1 = size.width * (0.8 + 0.1 * math.sin(t * math.pi * 2));
    final cy1 = size.height * (0.15 + 0.08 * math.cos(t * math.pi * 2));
    canvas.drawCircle(Offset(cx1, cy1), size.width * 0.45, paint);

    // Blob 2 – deep purple
    paint.color = const Color(0xFF6C3FD1).withOpacity(0.1);
    final cx2 = size.width * (0.1 + 0.08 * math.cos(t * math.pi * 2 + 1));
    final cy2 = size.height * (0.6 + 0.1 * math.sin(t * math.pi * 2 + 1));
    canvas.drawCircle(Offset(cx2, cy2), size.width * 0.5, paint);

    // Blob 3 – teal accent
    paint.color = const Color(0xFF1DBFB0).withOpacity(0.07);
    final cx3 = size.width * (0.5 + 0.15 * math.sin(t * math.pi * 2 + 2));
    final cy3 = size.height * (0.85 + 0.05 * math.cos(t * math.pi * 2 + 2));
    canvas.drawCircle(Offset(cx3, cy3), size.width * 0.4, paint);
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.t != t;
}