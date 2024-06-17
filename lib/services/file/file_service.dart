import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:test_app/services/file/ifile_service.dart';

class FileService implements IFileService {
  final String _baseUrl = 'https://kiddo-api-production.up.railway.app/services/files/';

  @override
  Future<Uint8List?> fetchFile(String filename, String accessToken) async {
    final url = '$_baseUrl$filename';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load image');
    }
  }
}
