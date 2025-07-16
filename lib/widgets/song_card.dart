import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String alt;

  const SongCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.alt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            placeholder: (_, __) => const CircularProgressIndicator(),
            errorWidget: (_, __, ___) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Semantics(
              label: alt,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(image: imageProvider),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
