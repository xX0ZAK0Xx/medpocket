import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../blocs/bloc.dart';
import '../configs/app_urls.dart';
import 'utils.dart';

void showImageSourceSheet(BuildContext context, ImageBloc bloc, String usedFor) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedImage02,
                color: Colors.black,
                size: 24.0,
              ),
              title: const Text('View'),
              onTap: () {
                Navigator.pop(context);
                openFullScreen(
                    context,
                    bloc.onlineImage
                        ? '${AppUrls.imageBaseUrl}/${bloc.resizedImagePath}'
                        : bloc.resizedImagePath,
                    "",
                    onlineImage: bloc.onlineImage);
              },
            ),
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedCamera01,
                color: Colors.black,
                size: 24.0.sp,
              ),
              title: const Text('Camera'),
              onTap: () {
                bloc.add(SelectImageEvent(fromCamera: true, usedFor: usedFor));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedAlbum02,
                color: Colors.black,
                size: 24.0.sp,
              ),
              title: const Text('Gallery'),
              onTap: () {
                bloc.add(SelectImageEvent(fromCamera: false, usedFor: usedFor));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
