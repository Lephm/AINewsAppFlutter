import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

import '../providers/theme_provider.dart';

class OnBoardingPage extends ConsumerStatefulWidget {
  const OnBoardingPage({super.key});

  @override
  ConsumerState<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      body: Center(
        child: TextButton(
          onPressed: () {
            saveHasLoadedOnBoardingPage();
          },
          child: Text("Pressme"),
        ),
      ),
    );
  }

  void saveHasLoadedOnBoardingPage() {
    localStorage.setItem("hasLoadedOnboarding", "true");
    Navigator.of(context).pushReplacementNamed("/");
  }
}
