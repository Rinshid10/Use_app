import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../model/picked_image.dart';

// Conditional imports for web vs mobile save/open
import 'pdf_saver_stub.dart'
    if (dart.library.js_interop) 'pdf_saver_web.dart'
    if (dart.library.io) 'pdf_saver_mobile.dart' as pdf_saver;

class ImageToPdfController extends GetxController {
  final selectedImages = <PickedImage>[].obs;
  final isConverting = false.obs;
  final conversionDone = false.obs;
  final progress = 0.0.obs;
  final statusText = ''.obs;
  final pdfReady = false.obs;

  Uint8List? _lastPdfBytes;
  String? _lastPdfPath;

  final _picker = ImagePicker();

  int get imageCount => selectedImages.length;
  bool get hasImages => selectedImages.isNotEmpty;
  bool get hasSavedPdf => pdfReady.value;

  // ── Image Picking ──

  Future<void> pickFromGallery() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 85);
    if (pickedFiles.isNotEmpty) {
      for (final xFile in pickedFiles) {
        final bytes = await xFile.readAsBytes();
        selectedImages.add(PickedImage(name: xFile.name, bytes: bytes));
      }
      _resetPdfState();
    }
  }

  Future<void> pickFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      selectedImages.add(PickedImage(name: pickedFile.name, bytes: bytes));
      _resetPdfState();
    }
  }

  // ── Image Management ──

  void removeImage(int index) {
    selectedImages.removeAt(index);
    _resetPdfState();
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final image = selectedImages.removeAt(oldIndex);
    selectedImages.insert(newIndex, image);
    pdfReady.value = false;
  }

  void clearAll() {
    selectedImages.clear();
    _resetPdfState();
  }

  // ── PDF Conversion ──

  Future<void> convertToPdf() async {
    if (!hasImages) return;

    isConverting.value = true;
    conversionDone.value = false;
    progress.value = 0.0;
    statusText.value = 'Preparing...';

    try {
      final pdf = pw.Document();

      for (int i = 0; i < selectedImages.length; i++) {
        progress.value = (i + 0.5) / selectedImages.length;
        statusText.value =
            'Processing image ${i + 1} of ${selectedImages.length}';

        final imageBytes = selectedImages[i].bytes;
        final image = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(0),
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image, fit: pw.BoxFit.contain),
              );
            },
          ),
        );

        progress.value = (i + 1) / selectedImages.length;
      }

      statusText.value = 'Saving PDF...';

      final pdfBytes = await pdf.save();
      _lastPdfBytes = Uint8List.fromList(pdfBytes);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'converted_$timestamp.pdf';

      _lastPdfPath = await pdf_saver.savePdf(
        bytes: _lastPdfBytes!,
        fileName: fileName,
      );

      isConverting.value = false;
      conversionDone.value = true;
      pdfReady.value = true;
      statusText.value = 'PDF created successfully!';
    } catch (e) {
      isConverting.value = false;
      statusText.value = 'Error: $e';
    }
  }

  Future<void> openPdf() async {
    if (!hasSavedPdf) return;

    if (kIsWeb) {
      // On web, re-download
      if (_lastPdfBytes != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        await pdf_saver.savePdf(
          bytes: _lastPdfBytes!,
          fileName: 'converted_$timestamp.pdf',
        );
      }
    } else {
      if (_lastPdfPath != null) {
        await pdf_saver.openPdf(_lastPdfPath!);
      }
    }
  }

  void startNewPdf() {
    selectedImages.clear();
    _resetPdfState();
  }

  // ── Private ──

  void _resetPdfState() {
    pdfReady.value = false;
    conversionDone.value = false;
    _lastPdfBytes = null;
    _lastPdfPath = null;
  }
}
