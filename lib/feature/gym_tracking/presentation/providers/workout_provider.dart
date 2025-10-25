import 'package:flutter/foundation.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import 'package:fittnes_tracker/core/di/service_locator.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutDao _dao = sl<AppDatabase>().workoutDao;

  List<WorkoutTableData> _templates = [];
  List<WorkoutTableData> get templates => _templates;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadTemplates() async {
    _loading = true;
    notifyListeners();
    try {
      _templates = await _dao.getWorkoutTemplates();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
