// ignore_for_file: prefer_int_literals

import 'dart:math';

import 'package:flutter/material.dart';

class ColorLoader extends StatefulWidget {
  const ColorLoader({Key? key, this.radius = 30.0, this.dotRadius = 3.0})
      : super(key: key);

  final double radius;
  final double dotRadius;
  @override
  _ColorLoaderState createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<ColorLoader>
    with SingleTickerProviderStateMixin {
  late Animation<double> animationRotation;
  late Animation<double> animationRadiusIn;
  late Animation<double> animationRadiusOut;
  late AnimationController controller;

  late double radius;
  late double dotRadius;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller
      ..addListener(() {
        setState(() {
          if (controller.value >= 0.75 && controller.value <= 1.0) {
            radius = widget.radius * animationRadiusIn.value;
          } else if (controller.value >= 0.0 && controller.value <= 0.25) {
            radius = widget.radius * animationRadiusOut.value;
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
      })
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      //color: Colors.black12,
      child: Center(
        child: RotationTransition(
          turns: animationRotation,
          child: Center(
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset.zero,
                  child: Dot(
                    radius: radius,
                    color: Colors.transparent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0),
                    radius * sin(0.0),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.amber,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 1 * pi / 4),
                    radius * sin(0.0 + 1 * pi / 4),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 2 * pi / 4),
                    radius * sin(0.0 + 2 * pi / 4),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.pinkAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 3 * pi / 4),
                    radius * sin(0.0 + 3 * pi / 4),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 4 * pi / 4),
                    radius * sin(0.0 + 4 * pi / 4),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.yellow,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 5 * pi / 4),
                    radius * sin(0.0 + 5 * pi / 4),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.lightGreen,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 6 * pi / 4),
                    radius * sin(0.0 + 6 * pi / 4),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.orangeAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 7 * pi / 4),
                    radius * sin(0.0 + 7 * pi / 4),
                  ),
                  child: Dot(
                    radius: dotRadius,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  const Dot({Key? key, this.radius, this.color}) : super(key: key);

  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
