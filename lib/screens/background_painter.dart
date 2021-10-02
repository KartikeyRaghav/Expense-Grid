import 'dart:math';
import 'dart:ui';
import 'package:expense_tracker/config/palette.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

class BackgroundPainter extends CustomPainter {
  BackgroundPainter({required Animation<double> animation})
      : bluePaint = Paint()
          ..color = Palette.orange
          ..style = PaintingStyle.fill,
        greyPaint = Paint()
          ..color = Palette.lightBlue
          ..style = PaintingStyle.fill,
        backPaint = Paint()
          ..color = Palette.back
          ..style = PaintingStyle.fill,
        liquidAnim = CurvedAnimation(
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeInBack,
            parent: animation),
        greyAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.8,
            curve: Interval(0, 0.9, curve: SpringCurve()),
          ),
          reverseCurve: Curves.easeInCirc,
        ),
        blueAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 0.8, curve: SpringCurve()),
          reverseCurve: Curves.easeInCirc,
        ),
        backAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 0.8, curve: SpringCurve()),
          reverseCurve: Curves.easeInCirc,
        ),
        super(repaint: animation);

  final Animation<double> liquidAnim;
  final Animation<double> blueAnim;
  final Animation<double> greyAnim;
  final Animation<double> backAnim;

  final Paint bluePaint;
  final Paint greyPaint;
  final Paint backPaint;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _addPointsToPath(Path path, List<Point> points) {
    if (points.length < 3) {
      throw UnsupportedError('Need three or more points to create a path.');
    }

    for (var i = 0; i < points.length - 2; i++) {
      final xc = (points[i].x + points[i + 1].x) / 2;
      final yc = (points[i].y + points[i + 1].y) / 2;
      path.quadraticBezierTo(points[i].x, points[i].y, xc, yc);
    }

    path.quadraticBezierTo(
        points[points.length - 2].x,
        points[points.length - 2].y,
        points[points.length - 1].x,
        points[points.length - 1].y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBack(canvas, size);
    paintBlue(canvas, size);
    paintGrey(size, canvas);
  }

  void paintBack(Canvas canvas, Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, backPaint);
  }

  void paintBlue(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(-200, 650);
    _addPointsToPath(path, [
      Point(lerpDouble(0, 0, blueAnim.value),
          lerpDouble(0, size.height + 130, blueAnim.value)),
      Point(lerpDouble(size.width / 2, size.width / 4 * 3, liquidAnim.value),
          lerpDouble(size.height / 2, size.height / 4 * 3, blueAnim.value)),
      Point(size.width,
          lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value)),
    ]);

    canvas.drawPath(path, bluePaint);
  }

  void paintGrey(Size size, Canvas canvas) {
    final path = Path();
    path.moveTo(size.width, 300);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(-10, 600);
    _addPointsToPath(
      path,
      [
        Point(
          size.width / 4,
          lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value),
        ),
        Point(
          size.width * 3 / 5,
          lerpDouble(size.height / 4, size.height / 2, liquidAnim.value),
        ),
        Point(
          size.width * 4 / 5,
          lerpDouble(size.height / 6, size.height / 3, greyAnim.value),
        ),
        Point(
          size.width,
          lerpDouble(size.height / 5, size.height / 4, greyAnim.value),
        ),
      ],
    );

    canvas.drawPath(path, greyPaint);
  }
}

class Point {
  // ignore: prefer_typing_uninitialized_variables
  final x;
  // ignore: prefer_typing_uninitialized_variables
  final y;

  Point(this.x, this.y);
}

class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return (-(pow(e, -t / a) * cos(t * w)) + 1).toDouble();
  }
}
