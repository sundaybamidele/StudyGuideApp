import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadFile(PlatformFile file) async {
    try {
      await _storage.ref('study_materials/${file.name}').putFile(File(file.path!));
    } catch (e) {
      if (kDebugMode) {
        print('Upload error: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> listFiles() async {
    List<Map<String, dynamic>> files = [];
    try {
      final ListResult result = await _storage.ref('study_materials').listAll();
      for (var ref in result.items) {
        final String url = await ref.getDownloadURL();
        files.add({'name': ref.name, 'url': url});
      }
    } catch (e) {
      if (kDebugMode) {
        print('List files error: $e');
      }
    }
    return files;
  }

  Future<String?> downloadFile(String fileName) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final localFile = File('${appDocDir.path}/$fileName');

      await _storage.ref('study_materials/$fileName').writeToFile(localFile);

      // Return the local file path
      if (await localFile.exists()) {
        return localFile.path;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Download error: $e');
      }
      return null;
    }
  }
}
