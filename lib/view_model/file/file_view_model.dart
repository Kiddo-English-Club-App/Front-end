import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:test_app/models/cache/chache.dart';
import 'package:test_app/services/file/ifile_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/file/ifile_view_model.dart';

class FileViewModel extends ChangeNotifier implements IFileViewModel {
  final IFileService _imageRepository;
  final SecureStorageHelper _secureStorageHelper;

  FileViewModel(this._imageRepository, this._secureStorageHelper);

  Uint8List? _fileData;
  Uint8List? get fileData => _fileData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  @override
  Future<void> fetchFile(String filename) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    // Intenta obtener la imagen del caché
    _fileData = ImageInnerCache.instance.getImage(filename);

    if (_fileData != null) {
      // Si la imagen está en caché, no se necesita llamar al servicio
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Si la imagen no está en caché, llama al servicio para obtenerla
    String? accessToken = await _secureStorageHelper.getValue('access_token');

    try {
      _fileData = await _imageRepository.fetchFile(filename, accessToken);

      // Almacena la imagen en caché para futuros accesos
      ImageInnerCache.instance.addImage(filename, _fileData!);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      _hasError = true;
      notifyListeners();
    }
  }
}
