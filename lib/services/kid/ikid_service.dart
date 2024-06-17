// lib/services/kid_service.dart

import 'package:test_app/models/kid/kid_model.dart';

abstract class IKidService {
  Future<List<KidModel>> fetchKids();
  Future<void> storeKidId(String kidId);
  Future<String?> getKidId();
}