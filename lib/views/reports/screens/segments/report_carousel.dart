import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../configs/app_sizes.dart';
import '../../../../configs/colors.dart';
import '../../../../models/model.dart';
import '../../../../widgets/widgets.dart';


class HotelCarouselImages extends StatelessWidget {
  const HotelCarouselImages({
    super.key,
    required this.carouselIndex,
    required this.reportOfFolderData, required this.reverse,
  });

  final ValueNotifier<int> carouselIndex;
  final ReportOfFolderData reportOfFolderData;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 70.h,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              reverse: reverse,
              height: 70.w,
              autoPlayAnimationDuration: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                carouselIndex.value = index;
              },
            ),
            items: reportOfFolderData.images?.map((image) {
              return AppCachedNetworkImage(url: image, height: 60.h, width: 60.h,);
            }).toList(),
          ),
          Positioned(
            bottom: AppSizes.bodyPadding,
            right: AppSizes.bodyPadding,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.bodyPadding / 2),
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig)
              ),
              child: ValueListenableBuilder(
                valueListenable: carouselIndex,
                builder: (_, value, __) {
                  return Text("${value + 1}/${reportOfFolderData.images?.length}", style: myText(color: AppColors.white, fontSize: 10.sp),);
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}