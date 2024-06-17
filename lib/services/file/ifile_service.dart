import 'dart:typed_data';

abstract class IFileService {
  Future<Uint8List?> fetchFile(String filename, String accessToken);
}
