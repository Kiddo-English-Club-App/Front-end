// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/models/report/report_model.dart';
import 'package:test_app/services/report/ireport_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';

class ReportService implements IReportService {
  final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();

  @override
  Future<ReportModel> fetchReport() async {
    String? childId = await _secureStorageHelper.getValue('kid_id');
    if (childId == null || childId.isEmpty) {
      throw Exception('Kid ID is not available');
    }

    String? accessToken = await _secureStorageHelper.getValue('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token is not available');
    }

    final response = await http.get(
      Uri.parse('https://kiddo-api-production.up.railway.app/api/scores/report/$childId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return ReportModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error fetching data: ${response.statusCode}');
    }
  }
}
