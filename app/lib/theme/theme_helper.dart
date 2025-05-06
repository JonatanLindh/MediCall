import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

class ThemeHelper {
  // The current app theme
  final String _appTheme = 'lightCode';

  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  ///Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  ///Returns the current theme data.
  ThemeData _getThemeData() {
    final colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
    );
  }

  ///Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  ///Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 26,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light();
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Black
  Color get black900 => const Color(0XFF000000);
  //Blue
  Color get blue200 => const Color(0XFF407CE2);
  //Gray
  Color get gray50 => const Color(0X0ff9fafb);
  Color get gray600 => const Color(0XFF777777);
  //Indigo
  Color get indigo50 => const Color(0XFFE4EBF7);
}
