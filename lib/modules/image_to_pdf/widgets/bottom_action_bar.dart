import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controller/image_to_pdf_controller.dart';
import 'add_image_bottom_sheet.dart';

class BottomActionBar extends GetView<ImageToPdfController> {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Add more button
            Material(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  if (!controller.isConverting.value) {
                    AddImageBottomSheet.show();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(
                    Icons.add_photo_alternate_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Convert button
            Expanded(
              child: Obx(() => FilledButton(
                    onPressed: !controller.hasImages || controller.isConverting.value
                        ? null
                        : controller.convertToPdf,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.isConverting.value
                              ? Icons.hourglass_top_rounded
                              : Icons.picture_as_pdf_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.isConverting.value
                              ? 'Converting...'
                              : controller.conversionDone.value
                                  ? 'Convert Again'
                                  : 'Convert to PDF',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
