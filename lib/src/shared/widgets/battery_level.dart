import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedBatteryWidget extends HookWidget {
  final int batteryPercentage;

  const AnimatedBatteryWidget({Key? key, required this.batteryPercentage})
      : super(key: key);

  Color getBatteryColor() {
    if (batteryPercentage < 20) {
      return Colors.redAccent;
    } else if (batteryPercentage < 50) {
      return Colors.orangeAccent;
    } else {
      return Colors.lightGreenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
      initialValue: 0,
      upperBound: batteryPercentage / 100.0,
    )..forward();

    return OverflowBox(
      maxWidth: 180.0,
      child: Stack(
        children: [
          Container(
            width: 170.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 3.0,
                  top: 4.0,
                  bottom: 4.0,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      double totalWidth = 160.0;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.0),
                          gradient: LinearGradient(
                            colors: [
                              getBatteryColor(),
                              getBatteryColor().withOpacity(0.8)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        width: animationController.value * totalWidth,
                      );
                    },
                  ),
                ),
                Center(
                  child: Text(
                    '$batteryPercentage%',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
