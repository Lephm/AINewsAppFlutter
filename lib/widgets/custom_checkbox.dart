import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomCheckBox extends ConsumerWidget {
  const CustomCheckBox({super.key, required this.isCheckboxOn, this.onChanged});
  final bool isCheckboxOn;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return Checkbox(
      value: isCheckboxOn,
      checkColor: currentTheme.currentColorScheme.bgPrimary,
      activeColor: currentTheme.currentColorScheme.bgInverse,
      onChanged: onChanged,
    );
  }
}
