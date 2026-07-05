import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final vaultFilesProvider = FutureProvider<List<FileSystemEntity>>((ref) async {
  return VaultService.listFiles();
});

class VaultService {
  static Future<Directory> _vaultDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final vault = Directory(p.join(dir.path, 'vault'));
    if (!await vault.exists()) {
      await vault.create(recursive: true);
    }
    return vault;
  }

  static Future<List<FileSystemEntity>> listFiles() async {
    final vault = await _vaultDir();
    final files = vault.listSync().whereType<File>().toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    return files;
  }

  static Future<String?> pickAndSave() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 2048, imageQuality: 90);
    if (file == null) return null;
    final vault = await _vaultDir();
    final ext = p.extension(file.path);
    final dest = p.join(vault.path, 'vault_${DateTime.now().millisecondsSinceEpoch}$ext');
    await File(file.path).copy(dest);
    return dest;
  }

  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static int totalBytes(List<FileSystemEntity> files) {
    return files.fold<int>(0, (sum, f) => sum + (f as File).lengthSync());
  }

  static String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
