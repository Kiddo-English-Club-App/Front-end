// lib/viewmodels/achievement_viewmodel.dart

import 'package:test_app/models/achievement/achievement_model.dart';
import 'package:test_app/services/achievement/iachievement_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/achievement/iachievement_view_model.dart';

class AchievementViewModel extends IAchievementViewModel {
  final IAchievementService _achievementService;
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  AchievementViewModel(this._achievementService);

  List<AchievementModel> _achievements = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  List<AchievementModel> get achievements => _achievements;

  @override
  bool get isLoading => _isLoading;

  @override
  String get errorMessage => _errorMessage;

  @override
  Future<void> fetchAchievements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final kidId = await _secureStorageHelper.getValue('kid_id');
      final token = await _secureStorageHelper.getValue('access_token');
      List<AchievementModel> fetchedAchievements = await _achievementService.fetchAchievements(kidId, token);
      _achievements = fetchedAchievements;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _achievements = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
