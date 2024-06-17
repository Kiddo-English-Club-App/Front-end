import 'dart:typed_data';
import 'package:flutter/material.dart';

abstract class IFileViewModel extends ChangeNotifier {
  bool get isLoading;
  bool get hasError;
  Uint8List? get fileData;

  Future<void> fetchFile(String filename);
}
