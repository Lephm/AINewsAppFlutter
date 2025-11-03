import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/full_screen_overlay_progress_bar.dart';
import 'package:centranews/utils/pop_up_message.dart';
import 'package:centranews/widgets/custom_safe_area.dart';
import 'package:centranews/widgets/form_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/validationhelper.dart';
import '../widgets/custom_form_button.dart';
import '../widgets/custom_textformfield.dart';

final supabase = Supabase.instance.client;

class ResetPasswordPromptPage extends ConsumerStatefulWidget {
  const ResetPasswordPromptPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordPromptPageState();
}

class _ResetPasswordPromptPageState
    extends ConsumerState<ResetPasswordPromptPage>
    with FullScreenOverlayProgressBar {
  final GlobalKey<FormState> _resetPasswordPromptFormKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return CustomSafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FormAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: SizedBox(
              width: double.infinity,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  resetPasswordPromptIntroWidget(),
                  resetPasswordPromptForm(),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      ),
    );
  }

  Widget resetPasswordPromptIntroWidget() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Column(
      children: [
        SizedBox(height: 80),
        Image(
          image: AssetImage("assets/app_icon.png"),
          height: 150,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
        SizedBox(height: 10),
        Text(
          localization.pleaseEnterAnEmail,
          style: currentTheme.textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget resetPasswordPromptForm() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return Form(
      key: _resetPasswordPromptFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: localization.enterYourEmail,
            controller: emailController,
            validatorFunc: (value) {
              return isEmailValid(value, localization);
            },
          ),

          CustomFormButton(
            onPressed: () async {
              if (_resetPasswordPromptFormKey.currentState!.validate()) {
                try {
                  showProgressBar(context, currentTheme);
                  await supabase.auth.resetPasswordForEmail(
                    emailController.text.trim(),
                  );
                  if (mounted) {
                    showSucessfulSendCodeMessage();
                  }
                } catch (e) {
                  if (mounted) {
                    showAlertMessage(context, e.toString(), currentTheme);
                  }
                } finally {
                  if (mounted) {
                    closeProgressBar(context);
                  }
                }
              }
            },
            content: localization.resetPassword,
          ),
        ],
      ),
    );
  }

  void showSucessfulSendCodeMessage() async {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,

        title: Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/reset_password");
            },
            child: Icon(
              Icons.arrow_forward,
              color: currentTheme.currentColorScheme.bgInverse,
              size: 30,
            ),
          ),
        ),
        content: Text(
          localization.weHaveSendResetPasswordCode,
          style: currentTheme.textTheme.bodyMedium,
        ),
      ),
    );
    if (mounted) {
      Navigator.of(context).pushNamed("/reset_password");
    }
  }
}
