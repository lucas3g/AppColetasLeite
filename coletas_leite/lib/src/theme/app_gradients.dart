import 'dart:math';

import 'package:flutter/material.dart';

abstract class AppGradients {
  Gradient get background;
}

class AppGradientsDefault implements AppGradients {
  @override
  Gradient get background => LinearGradient(
        colors: [
          Color(0xFFEB5757),
          Color(0xFFFF0000),
        ],
        transform: GradientRotation(2.35619 * pi),
      );
}
