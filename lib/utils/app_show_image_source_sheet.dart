import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../blocs/bloc.dart';
import '../configs/app_urls.dart';
import 'utils.dart';

void showImageSourceSheet(BuildContext context, ImageBloc bloc, String usedFor, {bool multiImage = false}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: [
            bloc.resizedImagePath.isNotEmpty && !multiImage ?
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
            ) : SizedBox.shrink(),
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedCamera01,
                color: Colors.black,
                size: 24.0.sp,
              ),
              title: const Text('Camera'),
              onTap: () {
                if(multiImage){
                  bloc.add(SelectMultipleImagesEvent(fromCamera: true, usedFor: usedFor));
                }else{
                  bloc.add(SelectImageEvent(fromCamera: true, usedFor: usedFor));
                }
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
                if(multiImage){
                  bloc.add(SelectMultipleImagesEvent(fromCamera: false, usedFor: usedFor,));
                }else{
                  bloc.add(SelectImageEvent(fromCamera: false, usedFor: usedFor));
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
