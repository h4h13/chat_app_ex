import 'package:chat_app_ex/core/ext/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,

    this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
    this.maxLength,
    this.maxLines,
    this.label,
    this.inputFormatters,
    required this.textFieldName,
    this.validators = const <FormFieldValidator>[],
    this.onFieldSubmitted,
    this.counterText,
    this.textCapitalization = TextCapitalization.sentences,
    this.suffixIcon,
    this.prefixIcon,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onSaved,
    this.onTap,
    this.focusNode,
    this.initialValue,
    this.autocorrect = false,
    this.autofocus = false,
    this.obscureText = false,
    this.autofillHints,
  });

  final Function(String?)? onChanged;
  final Function(String?)? onFieldSubmitted;
  final Function(String?)? onSaved;
  final Function()? onTap;
  final AutovalidateMode autoValidateMode;
  final TextEditingController? controller;
  final String? counterText;
  final bool enabled;
  final FocusNode? focusNode;
  final String hintText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final String? label;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final String textFieldName;
  final List<FormFieldValidator<String?>> validators;
  final bool autocorrect;
  final bool autofocus;
  final bool obscureText;
  final List<String>? autofillHints;
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      autofillHints: autofillHints,
      initialValue: initialValue,
      onTap: onTap,
      focusNode: focusNode,
      autovalidateMode: autoValidateMode,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      minLines: maxLines,
      autocorrect: autocorrect,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        labelText: label,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorMaxLines: 2,
        counterText: counterText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.12),
          ),
        ),
      ),
      onChanged: onChanged,
      validator: FormBuilderValidators.compose(<FormFieldValidator<String?>>[
        ...validators,
      ]),
      inputFormatters: inputFormatters,
      onSubmitted: onFieldSubmitted,
      name: textFieldName,
      onSaved: onSaved,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
