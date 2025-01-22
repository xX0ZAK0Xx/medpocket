import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../configs/app_sizes.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    super.key,
    required this.url,
    required this.height,
    required this.width,
  });
  final String url;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusBig),
      child: GestureDetector(
        onTap: () => openFullScreen(context, url, ""),
        child: CachedNetworkImage(
          imageUrl: url,
          height: height,
          width: width,
          fit: BoxFit.cover, // Ensures the image is scaled and cropped correctly.
          placeholder: (context, url) => Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
            child: ShimmerContainer(height: height, width: width),
          ),
          errorWidget: (context, url, error) => Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.broken_image,
              color: Colors.red,
              size: 40,
            ),
          ),
          imageBuilder: (context, imageProvider) => Image(
            image: imageProvider,
            fit: BoxFit.cover, // Keeps the aspect ratio of the image.
          ),
        ),
      ),
    );
  }
}
