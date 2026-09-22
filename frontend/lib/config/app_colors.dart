import 'package:flutter/material.dart';

class AppColors {
  
  static const Color primary = Color(0xFFE11D48); 
  static const Color primaryDark = Color(0xFFBE123C);
  static const Color primaryLight = Color(0xFFFDE8EC);
  static const Color primaryGradientStart = Color(0xFFE11D48);
  static const Color primaryGradientEnd = Color(0xFFFF4D79);

  
  static const Color secondary = Color(0xFF1E1B4B); 
  static const Color navyDark = Color(0xFF0F172A);
  static const Color purpleBadge = Color(0xFF4C1D95);
  static const Color purpleLight = Color(0xFFF3E8FF);
  
  static const Color teal = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFFCCFBF1);

  static const Color blueAccent = Color(0xFF2563EB);
  static const Color blueLight = Color(0xFFDBEAFE);

  static const Color discountRed = Color(0xFFE11D48);
  static const Color discountBadge = Color(0xFFDC2626);

  
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);
  
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  
  static const LinearGradient heroCardRed = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroCardNavy = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
