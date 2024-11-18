import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSliderWithFreeMovementAndDots extends StatefulWidget {
  const CustomSliderWithFreeMovementAndDots({super.key});

  @override
  _CustomSliderWithFreeMovementAndDotsState createState() =>
      _CustomSliderWithFreeMovementAndDotsState();
}

class _CustomSliderWithFreeMovementAndDotsState
    extends State<CustomSliderWithFreeMovementAndDots> {
  double _currentValue = 50.0;
  bool _showThumb = false;

  final List<double> _tickMarks = [0, 20, 40, 60, 80, 100];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.95;
    return SizedBox(
      width: width,
      height: 200,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Custom Dots and Track
          Positioned.fill(
            child: CustomPaint(
              painter: TickMarkPainter(
                tickMarks: _tickMarks,
                sliderWidth: width,
                thumbRadius: 10.0,
                currentValue: _currentValue,
              ),
            ),
          ),
          // Slider
          Positioned.fill(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,

                thumbColor: Colors.red,
                overlayColor: Colors.transparent,
                trackHeight: 0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0, elevation: 0, pressedElevation: 0),
              ),
              child: Slider(
                value: _currentValue,
                min: 0,
                max: 100,
                onChangeStart: (value) {
                  setState(() {
                    _showThumb = true;
                  });
                },
                onChangeEnd: (value) {
                  setState(() {
                    _showThumb = false;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _currentValue = _getClosestTick(value);
                  });
                },
              ),
            ),
          ),
          // Floating Widget
          if (_showThumb)
            Positioned(
              top: 0,
              left: _calculateWidgetPosition(context, width),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 75,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _currentValue.toStringAsFixed(0),
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }

  double _getClosestTick(double value) {
    const double snapThreshold =
        5.0; // Maximale Entfernung zu einem Tick, um zu snappen

    // Finde den nächsten Tick-Wert
    double? closestTick = _tickMarks.reduce((closest, tick) =>
        (tick - value).abs() < (closest - value).abs() ? tick : closest);

    // Überprüfe, ob der nächste Tick innerhalb des snapThreshold liegt
    if ((closestTick - value).abs() <= snapThreshold) {
      return closestTick; // Snap zum Tick
    }

    // Kein Snap, behalte den aktuellen Wert bei
    return value;
  }

  /// Berechnet die Position des Widgets basierend auf dem Slider-Wert
  double _calculateWidgetPosition(BuildContext context, double sliderWidth) {
    final double thumbRadius = 10.0; // Radius des Thumb
    final double widgetWidth = 100.0; // Breite des Widgets
    final double halfWidgetWidth = widgetWidth / 2;

    // Track-Grenzen berechnen
    final double trackStart = thumbRadius; // Start des Tracks
    final double trackEnd = sliderWidth - thumbRadius; // Ende des Tracks

    // Berechne die Position des Thumbs auf dem Track
    final double trackWidth = trackEnd - trackStart;
    double thumbPosition = trackStart + (_currentValue / 100) * trackWidth;

    // Wenn das Widget über die Grenzen hinausgeht, korrigiere die Position
    if (thumbPosition - halfWidgetWidth < trackStart) {
      return trackStart; // Klebt am Start
    } else if (thumbPosition + halfWidgetWidth > trackEnd) {
      return trackEnd - widgetWidth; // Klebt am Ende
    }

    // Widget bleibt zentriert über dem Thumb
    return thumbPosition - halfWidgetWidth;
  }
}

  class TickMarkPainter extends CustomPainter {
  final List<double> tickMarks;
  final double sliderWidth;
  final double thumbRadius;
  final double currentValue;

  TickMarkPainter({
    required this.tickMarks,
    required this.sliderWidth,
    required this.thumbRadius,
    required this.currentValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint für den inaktiven Track
    final inactiveTrackPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Paint für den aktiven Track
    final activeTrackPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final trackStart = thumbRadius + 12; // Start des Tracks (mit Daumenradius)
    final trackEnd = sliderWidth - thumbRadius - 12; // Ende des Tracks (mit Daumenradius)
    final trackWidth = trackEnd - trackStart;

    // Zeichne den inaktiven Track
    canvas.drawLine(
      Offset(trackStart, size.height / 2),
      Offset(trackEnd, size.height / 2),
      inactiveTrackPaint,
    );

    // Zeichne den aktiven Track (bis zum aktuellen Wert)
    final activeEndX = trackStart + (currentValue / 100) * trackWidth;
    canvas.drawLine(
      Offset(trackStart, size.height / 2),
      Offset(activeEndX, size.height / 2),
      activeTrackPaint,
    );

    // Paint für die Ticks
    final tickBorderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final tickFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Zeichne die Ticks
    for (var tick in tickMarks) {
      final dx = trackStart + (tick / 100) * trackWidth; // Berechnung der Tick-Position
      final dy = size.height / 2;

      // Zeichne die Füllung
      canvas.drawCircle(Offset(dx, dy), 4, tickFillPaint);

      // Zeichne den Rand
      canvas.drawCircle(Offset(dx, dy), 4, tickBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

