import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontBootstrap {
  FontBootstrap._();

  static Future<void> load() {
    return GoogleFonts.pendingFonts([
      GoogleFonts.orbitronTextTheme(),
      GoogleFonts.rajdhaniTextTheme(),
      GoogleFonts.orbitron(),
      GoogleFonts.orbitron(fontWeight: FontWeight.w600),
      GoogleFonts.orbitron(fontWeight: FontWeight.w700),
      GoogleFonts.rajdhani(),
      GoogleFonts.rajdhani(fontWeight: FontWeight.w600),
      GoogleFonts.rajdhani(fontWeight: FontWeight.w700),
    ]);
  }
}
