import 'package:flutter/material.dart';
import 'package:test_app/models/report/report_model.dart';

abstract class IReportViewModel with ChangeNotifier {
  bool get isLoading;
  String? get error;
  ReportModel? get report;

  Future<void> fetchReport();
}
