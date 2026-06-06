import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/gamio_theme.dart';

class NeonBorder extends StatefulWidget {
  final Widget child;
  final String borderType;
  final double radius;

  const NeonBorder({
    Key? key,
    required this.child,
    required this.borderType,
    this.radius = 24.0,
  }) : super(key: key);

  @override
  State<NeonBorder> createState() => _NeonBorderState();
}

class _NeonBorderState extends State<NeonBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (widget.borderType == 'border-neon' || widget.borderType == 'border-gold') {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NeonBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.borderType == 'border-neon' || widget.borderType == 'border-gold') {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.borderType.isEmpty) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.transparent,
        child: ClipOval(child: widget.child),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        BoxDecoration decoration;
        double padding = 2.0;

        switch (widget.borderType) {
          case 'border-bronze':
            decoration = BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFCD7F32), width: 3),
              boxShadow: GamioTheme.neonGlow(color: const Color(0xFFCD7F32), opacity: 0.4),
            );
            break;
          case 'border-silver':
            decoration = BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC0C0C0), width: 3),
              boxShadow: GamioTheme.neonGlow(color: const Color(0xFFC0C0C0), opacity: 0.5),
            );
            break;
          case 'border-gold':
            // Pulsar luz dorada
            final pulse = 0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi);
            decoration = BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFD700), width: 3),
              boxShadow: GamioTheme.neonGlow(
                color: const Color(0xFFFFD700), 
                opacity: 0.4 + (0.4 * pulse),
              ),
            );
            break;
          case 'border-neon':
            padding = 4.0;
            // Gradiente neón psicodélico rotativo
            decoration = const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: GamioTheme.primary,
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: GamioTheme.accent,
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            );
            break;
          default:
            return ClipOval(child: widget.child);
        }

        if (widget.borderType == 'border-neon') {
          return Container(
            width: widget.radius * 2 + padding * 2,
            height: widget.radius * 2 + padding * 2,
            decoration: decoration,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return SweepGradient(
                  colors: const [
                    GamioTheme.primary,
                    GamioTheme.accent,
                    GamioTheme.secondary,
                    GamioTheme.primary
                  ],
                  transform: GradientRotation(_controller.value * 2 * math.pi),
                ).createShader(bounds);
              },
              child: Container(
                margin: EdgeInsets.all(padding),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: GamioTheme.bgPrimary,
                ),
                child: ClipOval(
                  child: Container(
                    color: GamioTheme.bgPrimary,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          );
        }

        return Container(
          width: widget.radius * 2 + padding * 2,
          height: widget.radius * 2 + padding * 2,
          decoration: decoration,
          padding: EdgeInsets.all(padding),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: GamioTheme.bgPrimary,
            ),
            child: ClipOval(child: widget.child),
          ),
        );
      },
    );
  }
}
