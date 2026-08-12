import '../models/report.dart';
import '../core/utils/dummy_data.dart';
import '../core/utils/helpers.dart';

class ReportService {
  static List<IncidentReport> getUserReports() => DummyData.myReports;

  static IncidentReport? getReportById(String id) {
    try {
      return DummyData.myReports.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<String> submitReport(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return AppHelpers.generateRefNumber();
  }

  static Future<bool> updateReportStatus(
      String reportId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
