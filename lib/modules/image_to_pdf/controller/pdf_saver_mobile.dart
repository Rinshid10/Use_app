import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<String?> savePdf({
  required Uint8List bytes,
  required String fileName,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  return filePath;
}

Future<void> openPdf(String path) async {
  await OpenFile.open(path);
}
