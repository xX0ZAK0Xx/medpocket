import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../configs/app_sizes.dart';
import '../configs/colors.dart';
import 'widgets.dart';

class AppDecoratedTextField extends StatelessWidget {
  AppDecoratedTextField({
    required this.textInputAction,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.onEditingComplete,
    this.autofocus,
    FocusNode? focusNode,
    this.readOnly = false,
    this.fillColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.isRequired,
    this.maxLines = 1,
    this.needLabel = true,
    this.onTap,
  }) : focusNode = focusNode ?? FocusNode();

  final void Function()? onTap;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String labelText;
  final String hintText;
  final bool? autofocus;
  final bool readOnly;
  final FocusNode focusNode; // Default FocusNode
  final void Function()? onEditingComplete;
  final Color? fillColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final bool? isRequired;
  final bool needLabel;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (() {
        if (!readOnly) focusNode.requestFocus();
      }),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding, vertical: AppSizes.bodyPadding / 2),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 226, 228, 234),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        constraints: BoxConstraints(
          minHeight: 60.h, // Fixed height when there's no error
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (needLabel)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labelText,
                          style: myText(color: labelColor ?? AppColors.textColorb3, fontWeight: FontWeight.w500, fontSize: 12.sp),
                        ),
                        if (isRequired ?? false)
                          SizedBox(width: 5.w),
                        if (isRequired ?? false)
                          Text(
                            "*",
                            style: myText(color: AppColors.red, fontWeight: FontWeight.w500, fontSize: 12.sp),
                          ),
                      ],
                    ),
                  SizedBox(height: 5.h), // Spacing between label and input field
                  IgnorePointer(
                    ignoring: readOnly,
                    child: TextFormField(
                      maxLines: maxLines,
                      controller: controller,
                      keyboardType: keyboardType,
                      textInputAction: textInputAction,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      autofocus: autofocus ?? false,
                      obscureText: obscureText ?? false,
                      obscuringCharacter: '*',
                      onEditingComplete: onEditingComplete,
                      readOnly: readOnly,
                      cursorColor: textColor ?? AppColors.textColorb1,
                      style: myText(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.textColorb1),
                      textAlignVertical: TextAlignVertical.center,
                      autovalidateMode: AutovalidateMode.disabled, // Show errors only after interaction
                      validator: validator,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding: const EdgeInsets.all(0),
                        prefixIcon: prefixIcon,
                        hintText: hintText,
                        isDense: true,
                        filled: false,
                        fillColor: fillColor ?? const Color.fromARGB(255, 225, 228, 235),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: hintColor ?? Colors.grey.shade600,
                          fontSize: 14.sp,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.error(context), width: 0.5),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.error(context), width: 0.5),
                        ),
                      ),
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                ],
              ),
            ),
            if (suffixIcon != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding),
                child: suffixIcon,
              ),
          ],
        ),
      ),
    );
  }
}
