import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/core/di/service_locator.dart';
import 'package:flutter/foundation.dart';

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
