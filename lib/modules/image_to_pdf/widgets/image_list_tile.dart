import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../model/picked_image.dart';

class ImageListTile extends StatelessWidget {
  final PickedImage image;
  final int pageNumber;
  final VoidCallback onRemove;

  const ImageListTile({
    super.key,
    required this.image,
    required this.pageNumber,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail (using Image.memory for web compatibility)
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.memory(
              image.bytes,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Page $pageNumber',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  image.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          // Delete
          IconButton(
            onPressed: onRemove,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.close_rounded,
                color: Colors.red.shade400,
                size: 16,
              ),
            ),
          ),
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.drag_handle_rounded,
              color: Colors.grey.shade300,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
