import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );
  TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
  TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );
}
