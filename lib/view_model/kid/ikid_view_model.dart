import 'package:flutter/material.dart';
import 'package:test_app/models/kid/kid_model.dart';

abstract class IKidViewModel with ChangeNotifier {
  bool get isLoading;
  String? get error;
  List<KidModel>? get kids;
  String? get kidId;

  Future<void> fetchKids();
  Future<void> storeKidId(String kidId);
  Future<void> printKidId();
}
