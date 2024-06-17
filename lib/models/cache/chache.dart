import 'dart:typed_data';
import 'dart:collection';

class ImageInnerCache {
  static final ImageInnerCache _instance = ImageInnerCache._internal();

  // Cambiamos a un getter estático para acceder al singleton
  static ImageInnerCache get instance => _instance;

  // HashMap para almacenar las imágenes
  final Map<String, Uint8List> _cache = HashMap<String, Uint8List>();

  // Constructor privado
  ImageInnerCache._internal();

  // Método para añadir una imagen al caché
  void addImage(String identifier, Uint8List imageBytes) {
    _cache[identifier] = imageBytes;
  }
  
  // Método para obtener una imagen del caché
  Uint8List? getImage(String identifier) {
    return _cache[identifier];
  }
}
