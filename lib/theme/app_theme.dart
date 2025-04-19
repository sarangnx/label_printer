import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// generated using FlexColorScheme Playground
// https://rydmike.com/flexcolorscheme/themesplayground-latest/
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Playground built-in scheme made with FlexSchemeColor.from() API.
    colors: FlexSchemeColor.from(primary: const Color(0xFF065808), brightness: Brightness.light, swapOnMaterial3: true),
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Playground built-in scheme made with FlexSchemeColor.from() API.
    colors: FlexSchemeColor.from(
      primary: const Color(0xFF065808),
      primaryLightRef: const Color(0xFF065808), // The color of light mode primary
      secondaryLightRef: const Color(0xFF365B37), // The color of light mode secondary
      tertiaryLightRef: const Color(0xFF2C7E2E), // The color of light mode tertiary
      brightness: Brightness.dark,
      swapOnMaterial3: true,
    ),
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
