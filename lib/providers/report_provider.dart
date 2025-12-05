import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../services/db_helper.dart';

class ReportNotifier extends Notifier<List<ReportModel>> {
  @override
  List<ReportModel> build() {
    loadReports();
    return [];
  }

  Future<void> loadReports() async {
    final reports = await DatabaseHelper.instance.getAllReports();
    state = reports;
  }

  Future<void> addReport(ReportModel report) async {
    await DatabaseHelper.instance.insertReport(report);
    await loadReports();
  }

  Future<void> updateReport(ReportModel report) async {
    await DatabaseHelper.instance.updateReport(report);
    await loadReports();
  }

  Future<void> deleteReport(int id) async {
    await DatabaseHelper.instance.deleteReport(id);
    await loadReports();
  }
}

final reportProvider = NotifierProvider<ReportNotifier, List<ReportModel>>(() {
  return ReportNotifier();
});