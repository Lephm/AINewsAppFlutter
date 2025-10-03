import 'package:centranews/models/custom_color_scheme.dart';
import 'package:centranews/models/custom_theme.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, CustomTheme>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<CustomTheme> {
  ThemeNotifier() : super(CustomTheme(currentColorScheme: lightTheme));
}
