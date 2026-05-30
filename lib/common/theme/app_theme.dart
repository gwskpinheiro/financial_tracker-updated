import 'package:flutter/material.dart';

class AppColors {
  // Marca
  static const Color primary     = Color(0xFF4361EE);
  static const Color primaryDark = Color(0xFF3451D1);

  // Semântica
  static const Color income      = Color(0xFF2D9E6B);
  static const Color incomeLight = Color(0xFF1A3D2E);
  static const Color expense     = Color(0xFFE5534B);
  static const Color expenseLight= Color(0xFF3D1A1A);

  // Dark surfaces
  static const Color background  = Color(0xFF0F1117);
  static const Color surface     = Color(0xFF1A1D27);
  static const Color surfaceElevated = Color(0xFF22263A);
  static const Color divider     = Color(0xFF2A2D3E);
  static const Color inputFill   = Color(0xFF1E2130);

  // Texto
  static const Color textPrimary   = Color(0xFFEEEFF5);
  static const Color textSecondary = Color(0xFF8B90A7);
  static const Color textHint      = Color(0xFF4A4F6A);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.income,
    onSecondary: Colors.white,
    tertiary: AppColors.expense,
    onTertiary: Colors.white,
    error: AppColors.expense,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
  ),
  scaffoldBackgroundColor: AppColors.background,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w700,
    ),
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    surfaceTintColor: Colors.transparent,
  ),

  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      side: BorderSide(color: AppColors.divider),
    ),
    margin: EdgeInsets.zero,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.divider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.divider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
    hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
  ),

  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.textPrimary,
    unselectedLabelColor: AppColors.textSecondary,
    indicatorColor: AppColors.primary,
    dividerColor: AppColors.divider,
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  ),

  textTheme: const TextTheme(
    titleLarge:  TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 17),
    titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
    bodyLarge:   TextStyle(color: AppColors.textPrimary, fontSize: 14),
    bodyMedium:  TextStyle(color: AppColors.textSecondary, fontSize: 13),
    bodySmall:   TextStyle(color: AppColors.textSecondary, fontSize: 11),
  ),
);
