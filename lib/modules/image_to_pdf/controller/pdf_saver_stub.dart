import 'dart:typed_data';

Future<String?> savePdf({
  required Uint8List bytes,
  required String fileName,
}) async {
  throw UnsupportedError('Cannot save PDF on this platform');
}

Future<void> openPdf(String path) async {
  throw UnsupportedError('Cannot open PDF on this platform');
}
