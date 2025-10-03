import 'package:centranews/models/custom_color_scheme.dart';
import 'package:flutter/widgets.dart';

class CustomTextTheme {
  CustomTextTheme({required this.currentColorScheme});
  CustomColorScheme currentColorScheme;
  TextStyle get bodyMedium {
    return TextStyle(color: currentColorScheme.textSecondary);
  }

  TextStyle get bodyLightMedium {
    return TextStyle(color: currentColorScheme.textSecondary);
  }

  TextStyle get bodyInverseMedium {
    return TextStyle(color: currentColorScheme.textInverse);
  }

  TextStyle get bodyLarge {
    return TextStyle();
  }

  TextStyle get bodySmall {
    return TextStyle();
  }

  TextStyle get bodyBold {
    return TextStyle(
      fontSize: 15,
      color: currentColorScheme.textPrimary,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get headlineMedium {
    return TextStyle(fontSize: 30, color: currentColorScheme.textPrimary);
  }
}
