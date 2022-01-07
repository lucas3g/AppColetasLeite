import 'package:flutter/material.dart';

abstract class AppColors {
  Color get backgroundSecondary;
  Color get backgroundPrimary;
  Color get title;
  Color get button;
  Color get border;
  Color get labelInput;
  Color get primaryColor;
  Color get secondaryColor;
  Color get dropDownTextColor;
  Color get titleLogin;
  Color get backGroundSplash;
}

class AppColorDefault implements AppColors {
  @override
  Color get backgroundSecondary => Color(0xFF40B38C);

  @override
  Color get title => Colors.white;

  @override
  Color get button => Color(0xFF666666);

  @override
  Color get backgroundPrimary => Color(0xFFFFFFFF);

  @override
  Color get border => Color(0xFFC2C2C2);

  @override
  Color get labelInput => Color(0xFFFFFFFF);

  @override
  Color get primaryColor => Color(0xFF96242d);

  @override
  Color get secondaryColor => Color(0xffcf1f36);

  @override
  Color get dropDownTextColor => Color(0xFF000000);

  @override
  Color get titleLogin => Color(0xffcf1f36);

  @override
  Color get backGroundSplash => Color(0xFFEB5757);
}
