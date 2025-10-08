import 'package:centranews/models/language_localization.dart';

final RegExp emailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

String? isPasswordValid(String? value, LanguageLocalizationTexts localization) {
  if (value == null || value.isEmpty) {
    return localization.pleaseEnterAPassword;
  }
  if (value.length < 6) {
    return localization.passwordMustBeLonger;
  }
  return null;
}

String? isEmailValid(String? value, LanguageLocalizationTexts localization) {
  if (value == null || value.isEmpty) {
    return localization.pleaseEnterAnEmail;
  } else if (!emailValid.hasMatch(value)) {
    return localization.pleaseEnterAValidEmail;
  }

  return null;
}

String? isTheSamePassword(
  String? password,
  String? confirmedPassword,
  LanguageLocalizationTexts localization,
) {
  if (confirmedPassword == null || confirmedPassword.isEmpty) {
    return localization.pleaseConfirmYourPassword;
  }
  if (confirmedPassword != password) {
    return localization.passwordsDoNotMatch;
  }

  return null;
}
