import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pulsing_widget.dart';
import '../controller/image_to_pdf_controller.dart';
import '../widgets/add_image_bottom_sheet.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/image_count_bar.dart';
import '../widgets/image_list_tile.dart';
import '../widgets/progress_card.dart';
import '../widgets/success_card.dart';

class ImageToPdfView extends GetView<ImageToPdfController> {
  const ImageToPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 16),
            // Dynamic content area
            Obx(() {
              if (controller.isConverting.value) {
                return const ProgressCard();
              }
              if (controller.conversionDone.value) {
                return const SuccessCard();
              }
              if (controller.hasImages) {
                return const ImageCountBar();
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 12),
            // Image list / empty state
            Expanded(
              child: Obx(() => controller.hasImages
                  ? _buildImageList()
                  : const ImageEmptyState()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (!controller.hasImages && !controller.conversionDone.value) {
          return const SizedBox.shrink();
        }
        return const BottomActionBar();
      }),
      floatingActionButton: Obx(() {
        if (controller.hasImages || controller.conversionDone.value) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: AddImageBottomSheet.show,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Images',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      }),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.darkText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Title
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Image to PDF',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Select images & convert',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Open PDF button
          Obx(() {
            if (!controller.hasSavedPdf) return const SizedBox.shrink();
            return PulsingWidget(
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: controller.openPdf,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Open',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildImageList() {
    return Obx(() => ReorderableListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          itemCount: controller.imageCount,
          onReorder: controller.reorderImages,
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Material(
                  elevation: 8,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: AppColors.primary.withOpacity(0.3),
                  child: child,
                );
              },
              child: child,
            );
          },
          itemBuilder: (context, index) {
            final image = controller.selectedImages[index];
            return Padding(
              key: ValueKey('${image.name}_$index'),
              padding: const EdgeInsets.only(bottom: 10),
              child: ImageListTile(
                image: image,
                pageNumber: index + 1,
                onRemove: () => controller.removeImage(index),
              ),
            );
          },
        ));
  }
}
