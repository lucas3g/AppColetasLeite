import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme.dart';

abstract class AppTextStyles {
  TextStyle get title;
  TextStyle get button;
  TextStyle get labelInput;
  TextStyle get dropdownText;
  TextStyle get titleCharts;
  TextStyle get titleLogin;
}

class AppTextStylesDefault implements AppTextStyles {
  @override
  TextStyle get button => GoogleFonts.roboto(
      fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.colors.button);

  @override
  TextStyle get title => GoogleFonts.montserrat(
      fontSize: 20, color: AppTheme.colors.title, fontWeight: FontWeight.w700);

  @override
  TextStyle get labelInput => GoogleFonts.roboto(
      fontSize: 14,
      color: AppTheme.colors.labelInput,
      fontWeight: FontWeight.w700);

  @override
  TextStyle get dropdownText => GoogleFonts.roboto(
      fontSize: 14,
      color: AppTheme.colors.dropDownTextColor,
      fontWeight: FontWeight.w700);

  @override
  TextStyle get titleCharts => GoogleFonts.roboto(
      fontSize: 12,
      color: AppTheme.colors.dropDownTextColor,
      fontWeight: FontWeight.w700);

  @override
  TextStyle get titleLogin => GoogleFonts.montserrat(
      fontSize: 40,
      color: AppTheme.colors.titleLogin,
      fontWeight: FontWeight.w700);
}
