// lib/viewmodels/profile_viewmodel.dart

import 'package:test_app/models/profile/profile_model.dart';
import 'package:test_app/services/profile/interface_profile_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/profile/iprofile_view_model.dart';

class ProfileViewModel extends IProfileViewModel {
  final IProfileService _profileService;
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  ProfileViewModel(this._profileService);

  ProfileModel? _profile;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  ProfileModel? get profile => _profile;

  @override
  bool get isLoading => _isLoading;

  @override
  String get errorMessage => _errorMessage;

  @override
  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _secureStorageHelper.getValue('access_token');
      ProfileModel fetchedProfile = await _profileService.fetchProfile(token);
      _profile = fetchedProfile;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _profile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
