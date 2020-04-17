import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class Draw extends StatefulWidget {
  Color selectedColor;
  double strokeWidth;
  final double opacity;
  final bool isActive;

  Draw(
      {Key key,
      this.strokeWidth,
      this.opacity,
      this.selectedColor,
      this.isActive})
      : super(key: key);
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  double strokeWidth = 3.0;
  bool showBrushSettings = false;
  Color pickerColor = Colors.black;
  List<DrawingPoints> points = List();
  bool showBottomList = false;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  @override
  void initState() {
    super.initState();
    strokeWidth = widget.strokeWidth;
    print(widget.selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              if (widget.isActive) {
                RenderBox renderBox = context.findRenderObject();
                points.add(DrawingPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = strokeCap
                      ..isAntiAlias = true
                      ..color = widget.selectedColor.withOpacity(widget.opacity)
                      ..strokeWidth = widget.strokeWidth));
              }
            });
          },
          onPanStart: (details) {
            setState(() {
              if (widget.isActive) {
                RenderBox renderBox = context.findRenderObject();
                points.add(DrawingPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = strokeCap
                      ..isAntiAlias = true
                      ..color = widget.selectedColor.withOpacity(widget.opacity)
                      ..strokeWidth = widget.strokeWidth));
              }
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add(null);
            });
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(
              pointsList: points,
            ),
          ),
        ),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
