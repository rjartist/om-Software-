import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class GlobalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final bool isEditable;
  final bool isNumberInput;
  final FocusNode? focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const GlobalTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.isEditable = true,
    this.isNumberInput = false,
    this.focusNode,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.greytext(fontSize: 14)),
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            obscureText: obscureText ? loginProvider.isObscured : false,
            enabled: isEditable,
            cursorColor: AppColors.primaryTextColor,
            style: AppTextStyle.blackText(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
            keyboardType: isNumberInput
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.emailAddress,
            inputFormatters: isNumberInput
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))]
                : null,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              labelText: hintText,
              hintText: hintText,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: AppTextStyle.smallGrey(fontSize: 14.0),
              hintStyle: AppTextStyle.smallGrey(),
              filled: true,
              fillColor: AppColors.white,
              errorText: null, // prevent jumpy layout
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.borderColor.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              suffixIcon: obscureText
                  ? IconButton(
                      icon: Icon(
                        loginProvider.isObscured
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                        color: AppColors.grey,
                        size: 18,
                      ),
                      onPressed: loginProvider.toggleObscureText,
                    )
                  : null,
            ),
          ),
        ),

        // Smooth error display without layout jump
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
          child: errorText != null && errorText!.isNotEmpty
              ? Padding(
                  key: ValueKey(errorText),
                  padding: const EdgeInsets.only(top: 6, left: 8),
                  child: Text(
                    errorText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : const SizedBox(height: 0),
        ),
      ],
    );
  }
}
