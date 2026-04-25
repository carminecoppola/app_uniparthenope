import '../model/studentService/exam_data.dart';
import 'local_grades_service.dart';
import 'notification_service.dart';

class GradeSyncService {
  GradeSyncService({
    required LocalGradesService localGradesService,
    required NotificationService notificationService,
  })  : _localGradesService = localGradesService,
        _notificationService = notificationService;

  final LocalGradesService _localGradesService;
  final NotificationService _notificationService;

  Future<void> syncGrades({
    required List<ExamData> grades,
    required String cacheScope,
  }) async {
    final normalizedScope = cacheScope.trim().isEmpty ? 'default' : cacheScope;
    final hasCachedGrades =
        await _localGradesService.hasCachedGrades(cacheScope: normalizedScope);

    if (!hasCachedGrades) {
      await _localGradesService.saveGrades(
        grades,
        cacheScope: normalizedScope,
      );
      return;
    }

    final newGrades = await _localGradesService.checkForNewGrades(
      grades,
      cacheScope: normalizedScope,
    );

    for (final exam in newGrades) {
      if (exam.status.voto == null) continue;

      final courseName = exam.nome ?? 'Insegnamento sconosciuto';
      final grade = '${exam.status.voto}/30';
      final date = exam.status.data ?? DateTime.now().toString().split(' ')[0];

      await _notificationService.showGradeNotification(
        courseName: courseName,
        grade: grade,
        date: date,
      );
    }

    await _localGradesService.saveGrades(
      grades,
      cacheScope: normalizedScope,
    );
  }
}
