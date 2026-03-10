import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../model/feature_item.dart';

class HomeController extends GetxController {
  final features = <FeatureItem>[
    const FeatureItem(
      icon: Icons.picture_as_pdf_rounded,
      title: 'Image to PDF',
      subtitle: 'Convert images to PDF',
      gradientColors: AppColors.pdfGradient,
      isAvailable: true,
      route: AppRoutes.imageToPdf,
    ),
    const FeatureItem(
      icon: Icons.document_scanner_rounded,
      title: 'Text Scanner',
      subtitle: 'OCR text extraction',
      gradientColors: AppColors.scannerGradient,
    ),
    const FeatureItem(
      icon: Icons.compress_rounded,
      title: 'PDF Compressor',
      subtitle: 'Reduce file size',
      gradientColors: AppColors.compressGradient,
    ),
    const FeatureItem(
      icon: Icons.call_merge_rounded,
      title: 'Merge PDFs',
      subtitle: 'Combine multiple PDFs',
      gradientColors: AppColors.mergeGradient,
    ),
    const FeatureItem(
      icon: Icons.image_rounded,
      title: 'PDF to Image',
      subtitle: 'Extract pages as images',
      gradientColors: AppColors.pdfToImageGradient,
    ),
    const FeatureItem(
      icon: Icons.qr_code_scanner_rounded,
      title: 'QR Scanner',
      subtitle: 'Scan & generate QR',
      gradientColors: AppColors.qrGradient,
    ),
  ];

  int get availableCount => features.where((f) => f.isAvailable).length;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void onFeatureTap(FeatureItem feature) {
    if (feature.isAvailable && feature.route != null) {
      Get.toNamed(feature.route!);
    } else {
      Get.snackbar(
        'Coming Soon',
        '${feature.title} will be available soon!',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.hourglass_top_rounded, color: Colors.white, size: 18),
        duration: const Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: Colors.black87,
      );
    }
  }

  void onDownloadTap() {
    Get.snackbar(
      'Downloads',
      'PDFs are saved to your Documents folder',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      colorText: Colors.white,
      backgroundColor: Colors.black87,
    );
  }
}
