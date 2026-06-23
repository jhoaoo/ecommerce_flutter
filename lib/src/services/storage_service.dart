import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../core/app_role.dart';
import '../core/firebase_bootstrapper.dart';

class StorageUploadResult {
  const StorageUploadResult({
    required this.path,
    required this.downloadUrl,
    required this.contentType,
  });

  final String path;
  final String downloadUrl;
  final String contentType;

  Map<String, dynamic> toFirestoreMetadata() => {
        'filePath': path,
        'fileUrl': downloadUrl,
        'contentType': contentType,
      };
}

class StorageService {
  StorageService({required this.firebase});

  final FirebaseBootstrapper firebase;

  Future<StorageUploadResult> uploadProductAsset({
    required Uint8List bytes,
    required String sellerId,
    required String productId,
    required String fileName,
    required String contentType,
    required AppRole role,
  }) async {
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final path = 'products/$sellerId/$productId/${role.key}/$safeName';

    if (!firebase.isConnected) {
      return StorageUploadResult(
        path: path,
        downloadUrl: 'cloud-simulation://$path',
        contentType: contentType,
      );
    }

    final ref = FirebaseStorage.instance.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return StorageUploadResult(path: path, downloadUrl: await ref.getDownloadURL(), contentType: contentType);
  }
}
