import 'package:centranews/models/custom_theme.dart';
import 'package:flutter/material.dart';

mixin FullScreenOverlayProgressBar {
  Route<Object?>? _progressBarRoute;

  void showProgressBar(BuildContext context, CustomTheme currentTheme) {
    _progressBarRoute = DialogRoute(
      context: context,
      builder: (context) => Center(
        heightFactor: 0.5,
        widthFactor: 0.5,
        child: CircularProgressIndicator(
          color: currentTheme.currentColorScheme.bgInverse,
          backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        ),
      ),
    );
    try {
      Navigator.of(context).push(_progressBarRoute as DialogRoute<Object?>);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void closeProgressBar(BuildContext context) {
    try {
      if (_progressBarRoute != null) {
        Navigator.of(context).removeRoute(_progressBarRoute as Route<Object?>);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    _progressBarRoute = null;
  }
}
