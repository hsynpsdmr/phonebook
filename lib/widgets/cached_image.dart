import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/util/responsive_extensions.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, required this.profileImageUrl, required this.size});

  final String profileImageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(90.0),
      child: CachedNetworkImage(
        imageUrl: profileImageUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.fill,
        width: context.getWidth(size),
        height: context.getWidth(size),
        fadeOutDuration: const Duration(milliseconds: 200),
        fadeInDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
