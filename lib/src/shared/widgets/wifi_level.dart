import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedWifiWidget extends HookWidget {
  final int strength;

  const AnimatedWifiWidget({Key? key, required this.strength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 3),
    )..forward();

    final animation = Tween(begin: 0.0, end: strength.toDouble()).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(100, 100),
          painter: WifiPainter(animation.value),
        );
      },
    );
  }
}

class WifiPainter extends CustomPainter {
  final double value;

  WifiPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    const startAngle = 5 * 3.14 / 4;
    const sweepAngle = 3.14 / 2;

    Offset center = Offset(size.width / 2, size.height * 3 / 4);

    List<Color> gradientColors;

    if (value <= 1) {
      gradientColors = [Colors.deepOrange, Colors.redAccent];
    } else if (value <= 2) {
      gradientColors = [Colors.orangeAccent, Colors.yellowAccent];
    } else {
      gradientColors = [Colors.cyan, Colors.greenAccent];
    }

    final gradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: size.width),
    );

    double arcValue = value;
    if (arcValue >= 2) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2.5),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      arcValue -= 1;
    }

    if (arcValue >= 1) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 3.5),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      arcValue -= 1;
    }

    if (arcValue > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 5),
        startAngle,
        sweepAngle * arcValue,
        false,
        paint,
      );
    }

    paint.style = PaintingStyle.fill;
    paint.shader = gradient.createShader(
      Rect.fromCircle(
          center: Offset(center.dx, size.height * 3 / 4), radius: size.width),
    );

    double yOffset = size.height * 3 / 4;
    canvas.drawCircle(Offset(center.dx, yOffset), size.width / 20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
