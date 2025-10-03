import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/custom_input_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextFormField extends ConsumerStatefulWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.controller,
    this.validatorFunc,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validatorFunc;
  final IconButton? suffixIcon;
  final bool obscureText;
  final Widget? prefixIcon;
  @override
  ConsumerState<CustomTextFormField> createState() =>
      _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends ConsumerState<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return CustomInputContainer(
      child: IntrinsicHeight(
        child: TextFormField(
          validator: widget.validatorFunc,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
          obscureText: widget.obscureText,
          style: currentTheme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
