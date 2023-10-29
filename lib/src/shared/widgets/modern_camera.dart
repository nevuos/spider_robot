import 'dart:ui';
import 'package:flutter/material.dart';

class ModernCameraWidget extends StatefulWidget {
  final String cameraActivationText;
  const ModernCameraWidget({
    required this.cameraActivationText,
    Key? key,
  }) : super(key: key);

  @override
  ModernCameraWidgetState createState() => ModernCameraWidgetState();
}

class ModernCameraWidgetState extends State<ModernCameraWidget> {
  bool _isCameraOn = false;

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCamera,
      child: Container(
        color: Colors.grey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: const Icon(Icons.play_arrow,
                      size: 100, color: Colors.white),
                ),
              ),
            ),
            Positioned(
                bottom: 20,
                child: Text(widget.cameraActivationText,
                    style: const TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
