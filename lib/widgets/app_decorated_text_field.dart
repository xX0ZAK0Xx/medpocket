import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../configs/app_sizes.dart';
import '../configs/colors.dart';
import 'widgets.dart';

class AppDecoratedTextField extends StatelessWidget {
  const AppDecoratedTextField({
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
    this.focusNode,
    this.readOnly = false,
    this.fillColor, 
    this.labelColor, 
    this.hintColor, 
    this.textColor,
    this.isRequired,
    this.maxLines = 1,
    this.needLabel = true, 
    this.onTap
  });

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
  final FocusNode? focusNode;
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
      onTap: onTap, // Ensure the onTap works here
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding, vertical: AppSizes.bodyPadding / 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 228, 235),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig * 1.5),
        ),
        child: Stack(
          children: [
            if (needLabel)
              Positioned(
                top: 5.h,
                left: 5.w,
                child: Row(
                  children: [
                    Text(
                      labelText,
                      style: myText(color: labelColor ?? AppColors.textColorb3, fontWeight: FontWeight.w500),
                    ),
                    if (isRequired ?? false)
                      SizedBox(width: 5.w),
                    if (isRequired ?? false)
                      Text(
                        "*",
                        style: myText(color: AppColors.red, fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
              ),
            Positioned(
              left: 5.w,
              bottom: 5.h,
              right: 5.w, // Add a right constraint to avoid infinite width
              child: SizedBox(
                width: double.infinity, // Constrain the width of the TextFormField
                child: IgnorePointer(
                  ignoring: readOnly, // Ignore interactions when readOnly is true
                  child: TextFormField(
                    maxLines: maxLines,
                    controller: controller,
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    autofocus: autofocus ?? false,
                    validator: validator,
                    obscureText: obscureText ?? false,
                    obscuringCharacter: '*',
                    onEditingComplete: onEditingComplete,
                    readOnly: readOnly,
                    cursorColor: textColor ?? AppColors.textColorb1,
                    style: myText(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.textColorb1),
                    textAlignVertical: TextAlignVertical.center,
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
                        fontSize: 12.sp,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
