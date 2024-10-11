import 'package:flutter/material.dart';

import '../configs/app_sizes.dart';
import '../configs/colors.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.hint,
    this.value,
    required this.itemList,
    required this.onChanged,
    required this.itemBuilder,
    this.selectedItemNull
  });

  final String label, hint;
  final T? value;
  final List<T> itemList;
  final void Function(T?)? onChanged;
  final DropdownMenuItem<T> Function(T item) itemBuilder;
  final bool? selectedItemNull;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: selectedItemNull == true ? AppColors.error(context) : AppColors.primary, width: 0.5),
                  borderRadius:
                  BorderRadius.circular(AppSizes.bodyPadding - 5)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isDense: true,
                  isExpanded: true,
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
                  style: const TextStyle(color: AppColors.textColorb1),
                  items: itemList.map(itemBuilder).toList(),
                  value: value,
                  onChanged: onChanged,
                  hint: Text(hint,style: const TextStyle(fontWeight: FontWeight.normal),maxLines: 1,overflow: TextOverflow.ellipsis,),
                ),
              ),
            ),

            Positioned(
                top: -2,
                left: 10,
                child: Container(
                    color: AppColors.bg,
                    child: Text(
                      " $label ",
                      style: const TextStyle(color: AppColors.textColorb2),
                    )))
          ],
        ),
        if(selectedItemNull == true)
          Text("Please select a ${label.toLowerCase()}",style: TextStyle(color: AppColors.error(context), fontSize: 12),)

      ],
    );
  }
}