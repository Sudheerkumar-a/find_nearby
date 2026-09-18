import 'package:flutter/material.dart';

/// GX Inspecta–inspired tokens for FindNearby.
/// Source: Field Inspection screen templates (teal header, coral accents, dark nav).
abstract final class AppColors {
  // Brand
  static const Color teal = Color(0xFF2A9D8F);
  static const Color tealDark = Color(0xFF1F7A6F);
  static const Color tealDeep = Color(0xFF176B61);
  static const Color coral = Color(0xFFE76F51);
  static const Color coralStrong = Color(0xFFD8573A);
  static const Color amber = Color(0xFFF4A261);
  static const Color success = Color(0xFF2A9D5C);

  // Surfaces
  static const Color scaffold = Color(0xFFF3F5F7);
  static const Color card = Color(0xFFFFFFFF);
  static const Color navy = Color(0xFF1C2434);
  static const Color navySoft = Color(0xFF2A3344);

  // Text
  static const Color ink = Color(0xFF1F2933);
  static const Color inkMuted = Color(0xFF6B7280);
  static const Color onTeal = Color(0xFFFFFFFF);
  static const Color onCoral = Color(0xFFFFFFFF);
  static const Color onNavy = Color(0xFFFFFFFF);

  // Soft tint cards (pending / completed style)
  static const Color tintPeach = Color(0xFFFFF1EC);
  static const Color tintMint = Color(0xFFE8F6F3);

  static const LinearGradient brandFooter = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFF8E24AA)],
  );

  static const LinearGradient tealHeader = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34B3A4), teal, tealDark],
  );
}
