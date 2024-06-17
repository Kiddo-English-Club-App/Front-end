
import 'package:test_app/models/report/report_model.dart';

abstract class IReportService {
  Future<ReportModel> fetchReport();
}
