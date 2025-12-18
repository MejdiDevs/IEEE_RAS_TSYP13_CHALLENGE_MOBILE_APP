import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide font utilities
/// 
/// Primary font: Orbitron (for headings, titles, buttons)
/// Secondary font: Inter (for body text, descriptions, labels)
class AppFonts {
  // Primary font - Orbitron (futuristic, bold)
  static TextStyle orbitron({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.orbitron(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Secondary font - Inter (clean, readable)
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Special font - Press Start 2P (pixelated, retro)
  static TextStyle pressStart2P({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.pressStart2p(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Helper to get primary font for headings
  static TextStyle heading({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return orbitron(
      fontSize: fontSize ?? 24,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }

  // Helper to get secondary font for body text
  static TextStyle body({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return inter(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
}

