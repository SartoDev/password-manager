import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeComponent {
  final TextTheme textTheme;

  const ThemeComponent(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff66798f),
      surfaceTint: Colors.red,
      onPrimary: Color(0xFFE8EBED),
      primaryContainer: Color(0xFFE8EBED),
      onPrimaryContainer: Color(0xff0075ff),
      secondary: Colors.red,
      onSecondary: Colors.red,
      secondaryContainer: Colors.transparent,
      onSecondaryContainer: Colors.black,
      tertiary: Colors.red,
      onTertiary: Colors.red,
      tertiaryContainer: Color(4290571250),
      onTertiaryContainer: Color(4278198051),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(0xFFE8EEFC),
      onSurface: Color(0xFF40474F),
      onSurfaceVariant: Color(0xFF40474F),
      outline: Color(4285692271),
      outlineVariant: Color(4290955709),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4288599197),
      primaryFixed: Colors.red,
      onPrimaryFixed: Colors.red,
      primaryFixedDim: Color(4288599197),
      onPrimaryFixedVariant: Colors.red,
      secondaryFixed: Color(4292143312),
      onSecondaryFixed: Color(4279246608),
      secondaryFixedDim: Color(4290366645),
      onSecondaryFixedVariant: Color(4282010425),
      tertiaryFixed: Colors.red,
      onTertiaryFixed: Colors.red,
      tertiaryFixedDim: Colors.red,
      onTertiaryFixedVariant: Colors.red,
      surfaceDim: Colors.red,
      surfaceBright: Colors.red,
      surfaceContainerLowest: Colors.red,
      surfaceContainerLow: Color(0xFFE7EBEF),
      surfaceContainer: Color(0xFFEDF6FF),
      surfaceContainerHigh: Color(0xFFE8EBED),
      surfaceContainerHighest: Color(0xFFE8EBED),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder()),
      dialogTheme: DialogTheme(
          backgroundColor: colorScheme.surface,
          titleTextStyle: textTheme.titleLarge),
      dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(colorScheme.surface)),
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder())),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: colorScheme.surface),
      dividerTheme: DividerThemeData(color: colorScheme.primary),
      drawerTheme: DrawerThemeData(backgroundColor: colorScheme.surface),
      appBarTheme: AppBarTheme(
          titleTextStyle: textTheme.titleMedium,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.primary),
      iconTheme: IconThemeData(color: colorScheme.primary),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.surface),
      navigationBarTheme:
          NavigationBarThemeData(backgroundColor: colorScheme.surface),
      listTileTheme: ListTileThemeData(titleTextStyle: textTheme.titleMedium),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.surface)),
      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
              foregroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)))),
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface);

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288599197),
      surfaceTint: Color(4288599197),
      onPrimary: Color(4278466834),
      primaryContainer: Color(4280242215),
      onPrimaryContainer: Color(4290375863),
      secondary: Color(4290366645),
      onSecondary: Color(4280562724),
      secondaryContainer: Color(4282010425),
      onSecondaryContainer: Color(4292143312),
      tertiary: Color(4288794326),
      onTertiary: Color(4278203964),
      tertiaryContainer: Color(4280241491),
      onTertiaryContainer: Color(4290571250),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(0xFF212529),
      onSurface: Color(4292928731),
      onSurfaceVariant: Color(4290955709),
      outline: Color(4287402889),
      outlineVariant: Color(4282534208),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4281887036),
      primaryFixed: Color(4290375863),
      onPrimaryFixed: Color(4278198535),
      primaryFixedDim: Color(4288599197),
      onPrimaryFixedVariant: Color(4280242215),
      secondaryFixed: Color(4292143312),
      onSecondaryFixed: Color(4279246608),
      secondaryFixedDim: Color(4290366645),
      onSecondaryFixedVariant: Color(4282010425),
      tertiaryFixed: Color(4290571250),
      onTertiaryFixed: Color(4278198051),
      tertiaryFixedDim: Color(4288794326),
      onTertiaryFixedVariant: Color(4280241491),
      surfaceDim: Color(4279244048),
      surfaceBright: Color(4281743924),
      surfaceContainerLowest: Color(4278914827),
      surfaceContainerLow: Color(4279770392),
      surfaceContainer: Color(4280033563),
      surfaceContainerHigh: Color(4280757030),
      surfaceContainerHighest: Color(4281415216),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }
}
