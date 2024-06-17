import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utility/secure_storage_helper.dart';

class ScoreService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  Future<void> sendScore({
    required String themeId,
    required int points,
    required double time,
  }) async {
    // Obtiene el token de acceso
    String? accessToken = await _secureStorageHelper.getValue('access_token');
    if (accessToken.isEmpty) {
      throw Exception('Access token is not available');
    }

    // Obtiene el guest_id (childId)
    String? guestId = await _secureStorageHelper.getValue('kid_id');
    if (guestId.isEmpty) {
      throw Exception('Kid ID is not available');
    }

    // URL del endpoint para enviar la puntuación
    final url = Uri.parse('https://kiddo-api-production.up.railway.app/api/scores/');

    // Datos a enviar en el cuerpo de la solicitud POST
    final Map<String, dynamic> postData = {
      "theme_id": themeId,
      "guest_id": guestId,
      "points": points,
      "time": time,
    };

    // Encabezados necesarios, incluyendo el token de autenticación
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(postData), // Codificar los datos como JSON
      );

      // Verificar el código de respuesta
      if (response.statusCode == 200) {
        // Éxito al enviar la puntuación
        print('Puntuación enviada exitosamente');
      } else {
        // Error al enviar la puntuación
        print('Error al enviar la puntuación: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        // Puedes manejar el error de otra manera según tus necesidades
      }
    } catch (e) {
      // Manejar errores de red u otros errores
      print('Error en la solicitud HTTP: $e');
    }
  }
}
