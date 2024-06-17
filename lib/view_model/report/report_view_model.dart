
import 'package:test_app/models/report/report_model.dart';
import 'package:test_app/services/report/ireport_service.dart';
import 'package:test_app/view_model/report/ireport_view_model.dart';

class ReportViewModel extends IReportViewModel {
  final IReportService _reportService;

  ReportViewModel(this._reportService);

  bool _isLoading = false;
  String? _error;
  ReportModel? _report;

  @override
  bool get isLoading => _isLoading;
  @override
  String? get error => _error;
  @override
  ReportModel? get report => _report;

  @override
  Future<void> fetchReport() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _report = await _reportService.fetchReport();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
