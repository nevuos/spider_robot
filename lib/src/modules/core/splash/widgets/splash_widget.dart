import 'package:flutter/material.dart';
import '../constants/splash_constants.dart';

class SplashWidget extends StatelessWidget {
  final Animation<double> animation;

  const SplashWidget({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: const Text(
              kSplashTitle,
              style: kSplashTextStyle,
            ),
          ),
          const SizedBox(height: kSplashSpacing * 2),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: kCircularProgressGradientBegin,
                end: kCircularProgressGradientEnd,
                colors: [kSpinKitStartColor, kSpinKitEndColor],
              ).createShader(bounds);
            },
            child: const ClipOval(
              child: SizedBox(
                width: kCircularProgressSize,
                height: kCircularProgressSize,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.transparent,
                  strokeWidth: kCircularProgressStrokeWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
