import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart'; // Added to resolve rootBundle

class FirebaseStorageHelper {
  static final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  static Future<String> uploadImageFile(File imageFile, String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return ''; // Placeholder for logging
    }
  }

  static Future<String> uploadAssetToStorage(
    String assetPath,
    String filePath,
  ) async {
    try {
      final byteData = await rootBundle.load(
        assetPath,
      ); // Now works with import
      final file = File('tmp/$filePath');
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
      final ref = _storage.ref().child(filePath);
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      await file.delete();
      return downloadUrl;
    } catch (e) {
      return ''; // Placeholder for logging
    }
  }
}
