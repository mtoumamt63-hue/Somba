import 'package:flutter/material.dart';

/// Palette de couleurs Ultra-Premium (Design System Inspiré d'Apple, Stripe & Linear).
abstract class AppColors {
  // --- Couleurs Primaires & Accents ---
  static const Color primary = Color(0xFF4F46E5); // Electric Indigo 600
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primarySubtle = Color(0xFFEEF2FF); // Indigo 50
  static const Color primaryGlow = Color(0x334F46E5); // 20% Glow

  static const Color accent = Color(0xFF10B981); // Emerald Glow
  static const Color accentDark = Color(0xFF059669);
  static const Color accentLight = Color(0xFF34D399);
  static const Color accentSubtle = Color(0xFFECFDF5);

  static const Color coral = Color(0xFFFF5757); // Coral Red
  static const Color gold = Color(0xFFF59E0B); // Amber Gold
  static const Color goldSubtle = Color(0xFFFEF3C7);

  // --- Surfaces & Fonds : Mode Clair (Pearl White & Pure Slate) ---
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceSecondaryLight = Color(0xFFF1F5F9); // Slate 100
  static const Color cardLight = Color(0xFFFFFFFF);

  // --- Surfaces & Fonds : Mode Sombre (Obsidian Deep & Midnight Slate) ---
  static const Color backgroundDark = Color(0xFF090D16); // Deep Obsidian
  static const Color surfaceDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceSecondaryDark = Color(0xFF1E293B); // Slate 800
  static const Color cardDark = Color(0xFF131C31); // Elevated Dark Slate

  // --- Typographie & Textes ---
  static const Color textPrimaryLight = Color(0xFF0F172A); // Deep Slate
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate 500
  static const Color textMutedLight = Color(0xFF94A3B8); // Slate 400

  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Pure Light Slate
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
  static const Color textMutedDark = Color(0xFF64748B); // Slate 500

  // Alias rétrocompatibles
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textMuted = textMutedLight;
  static const Color textLight = Colors.white;

  // --- États Sémantiques ---
  static const Color success = Color(0xFF10B981);
  static const Color successSubtle = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSubtle = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSubtle = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSubtle = Color(0xFFDBEAFE);

  // --- Bordures & Lignes Fines ---
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF1E293B);
  static const Color border = borderLight;

  // --- Squelettes Shimmer ---
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF1F5F9);
  static const Color shimmerBaseDark = Color(0xFF1E293B);
  static const Color shimmerHighlightDark = Color(0xFF334155);

  static const Color shimmerBase = shimmerBaseLight;
  static const Color shimmerHighlight = shimmerHighlightLight;

  // --- Dégradés Signatures ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldMemberGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B), Color(0xFFFCD34D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
