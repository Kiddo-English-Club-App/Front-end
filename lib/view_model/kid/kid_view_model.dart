// lib/viewmodels/kid_viewmodel.dart

import 'package:test_app/models/kid/kid_model.dart';
import 'package:test_app/services/kid/ikid_service.dart';
import 'package:test_app/view_model/kid/ikid_view_model.dart';

class KidViewModel extends IKidViewModel {
  final IKidService _kidService;

  KidViewModel(this._kidService);

  List<KidModel>? _kids;
  bool _isLoading = false;
  String? _error;
  String? _kidId;

  @override
  bool get isLoading => _isLoading;
  @override
  String? get error => _error;
  @override
  List<KidModel>? get kids => _kids;
  @override
  String? get kidId => _kidId;

  @override
  Future<void> fetchKids() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _kids = await _kidService.fetchKids();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> storeKidId(String kidId) async {
    await _kidService.storeKidId(kidId);
    _kidId = kidId;
    notifyListeners();
  }

  @override
  Future<void> printKidId() async {
    final kidId = await _kidService.getKidId();
    print('Kid ID: $kidId');
  }
}
