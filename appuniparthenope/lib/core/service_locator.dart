import 'package:get_it/get_it.dart';
import '../service/api_checkexam_service.dart';
import '../service/api_login_service.dart';
import '../service/api_student_service.dart';
import '../service/api_teacher_service.dart';
import '../service/api_weather_service.dart';
import '../service/api_univerisity_service.dart';
import '../service/notification_service.dart';
import '../service/update_service.dart';

/// Service Locator globale per Dependency Injection
final getIt = GetIt.instance;

/// Configura tutte le dipendenze dell'applicazione
void setupServiceLocator() {
  // Registra tutti i servizi API come Singleton
  // Singleton = una sola istanza per tutta l'app

  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<ApiCheckExamService>(() => ApiCheckExamService());
  getIt.registerLazySingleton<ApiStudentService>(() => ApiStudentService());
  getIt.registerLazySingleton<ApiTeacherService>(() => ApiTeacherService());
  getIt.registerLazySingleton<ApiWeatherService>(() => ApiWeatherService());
  getIt.registerLazySingleton<ApiUniversityService>(
      () => ApiUniversityService());

  // Servizi di notifiche e aggiornamenti
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<UpdateService>(() => UpdateService());

  // I provider continuano ad essere gestiti da Provider/MultiProvider in main.dart
  // Non li mettiamo in GetIt per evitare conflitti con il sistema Provider esistente
}

/// Reset del service locator (utile per testing)
void resetServiceLocator() {
  getIt.reset();
}
