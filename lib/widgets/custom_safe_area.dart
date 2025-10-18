import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSafeArea extends ConsumerWidget {
  const CustomSafeArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return Container(
      color: currentTheme.currentColorScheme.bgPrimary,
      child: SafeArea(child: child),
    );
  }
}
