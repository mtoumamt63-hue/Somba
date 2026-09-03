import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Champ de texte personnalisé pour les écrans d'authentification Somba.
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      obscured: obscureText,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondaryLight,
        labelStyle: TextStyle(
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
}
