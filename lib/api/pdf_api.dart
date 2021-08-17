import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFApi {
  static Future<File> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    return _storeFile(path, bytes);
  }

  static Future<File> addFileToAssets(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    return _storeFile(path, bytes);
  }

  // static Future<File> loadNetwork(String url) async {
  //   final response = await http.get(url);
  //   final bytes = response.bodyBytes;

  //   return _storeFile(url, bytes);
  // }

  static Future<File> pickPDF(String path) async {
    String? pathString;
    if (path.isEmpty) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      pathString = result!.paths.first!;
    } else {
      pathString = path;
    }

    return File(pathString);
  }

  static Future<File> pickEPUB() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub'],
    );

    // if (result == null) return null;
    return File(result!.paths.first!);
  }

  // static Future<File> loadFirebase(String url) async {
  //   try {
  //     final refPDF = FirebaseStorage.instance.ref().child(url);
  //     final bytes = await refPDF.getData();

  //     return _storeFile(url, bytes);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  // static Future<File> _storeFileToDatabase(String url, List<int> bytes) async {
  //   final filename = basename(url);
  //   final dir = await getApplicationDocumentsDirectory();
  //
  //   final file = File('${dir.path}/$filename');
  //   await file.writeAsBytes(bytes, flush: true);
  //   return file;
  // }
}
