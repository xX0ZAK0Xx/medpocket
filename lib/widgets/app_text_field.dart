/*
App Text Form Field
@Author Soton Ahmed <soton.m360ict@gmail.com>
Start Date: 28-11-2023
Last Update: 28-11-2023
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/widgets/app_text_style.dart';

import '../configs/app_sizes.dart';
import '../configs/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {required this.textInputAction,
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
    });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: myText(color: labelColor??AppColors.textColorb1),
            ),
            if(isRequired??false)
            SizedBox(width: 5.w,),
            if(isRequired??false)
            Text(
              "*",
              style: myText(color: AppColors.red, fontWeight: FontWeight.w500),
            ),

          ],
        ),
        SizedBox(height: AppSizes.bodyPadding),
        TextFormField(
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
          style: myText(color: textColor??AppColors.textColorb1),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            // labelText: labelText,
            hintText: hintText,
            isDense: true,
            filled: true,
            fillColor: fillColor ?? AppColors.bg,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // labelStyle: const TextStyle(color: AppColors.textColorb3),
            hintStyle: TextStyle(fontWeight: FontWeight.w400, color: hintColor??Colors.grey.shade500),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide: BorderSide(color: AppColors.error(context),width: 0.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide: const BorderSide(color: AppColors.seed,width: 0.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide: const BorderSide(color: AppColors.primary,width: 0.0)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide: BorderSide(color: AppColors.error(context),width: 0.5)),
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}
