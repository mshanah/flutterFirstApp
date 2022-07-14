import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:flutter/material.dart';

class ThemeSettingChange extends Notification {
  ThemeSettingChange({required this.settings});
  final ThemeSettings settings;
}

class ThemeSettings {
  ThemeSettings({
    required this.sourceColor,
    required this.themeMode,
  });

  final Color sourceColor;
  final ThemeMode themeMode;
}

class ThemeProvider extends InheritedWidget {
  const ThemeProvider(
      {super.key,
      required this.settings,
      required this.lightDynamic,
      required this.darkDynamic,
      required super.child});

  final ValueNotifier<ThemeSettings> settings;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant ThemeProvider oldWidget) {
    return oldWidget.settings != settings;
  }

  AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      //elevation: 0,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
    );
  }

  Color blend(Color targetColor) {
    return Color(
        Blend.harmonize(targetColor.value, settings.value.sourceColor.value));
  }

  Color source(Color? target) {
    Color source = settings.value.sourceColor;
    if (target != null) {
      source = blend(target);
    }
    return source;
  }

  ColorScheme colors(Brightness brightness, Color? targetColor) {
    final dynamicPrimary = brightness == Brightness.light
        ? lightDynamic?.primary
        : darkDynamic?.primary;
    final color = dynamicPrimary ?? source(targetColor);

    return ColorScheme.fromSeed(
      seedColor: color,
      brightness: brightness,
    );
  }

  ThemeData light([Color? targetColor]) {
    final colorScheme = colors(Brightness.light, targetColor);

    return ThemeData.light().copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      useMaterial3: true,
      appBarTheme: appBarTheme(colorScheme),
    );
  }

  ThemeData dark([Color? targetColor]) {
    final colorScheme = colors(Brightness.dark, targetColor);

    return ThemeData.dark().copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      useMaterial3: true,
      appBarTheme: appBarTheme(colorScheme),
    );
  }

  ThemeMode themeMode() {
    return settings.value.themeMode;
  }
}
