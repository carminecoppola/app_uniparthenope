import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inizializza il servizio di notifiche
  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  /// Richiede i permessi per le notifiche (iOS 13+)
  Future<bool> requestPermissions() async {
    final result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? false;
  }

  /// Invia una notifica quando un voto viene inserito a libretto
  Future<void> showGradeNotification({
    required String courseName,
    required String grade,
    required String date,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'grade_channel',
      'Voti a Libretto',
      channelDescription: 'Notifiche per voti inseriti a libretto',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      '📚 Nuovo voto inserito',
      'Insegnamento: $courseName\nVoto: $grade\nData: $date',
      notificationDetails,
      payload: 'grade-$courseName',
    );
  }

  /// Invia una notifica generica personalizzata
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'general_channel',
      'Notifiche Università',
      channelDescription: 'Notifiche generali dall\'app',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notificationsPlugin.show(
      id ?? DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Invia una notifica di aggiornamento disponibile
  Future<void> showUpdateNotification({
    required String newVersion,
    required String releaseNotes,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'update_channel',
      'Aggiornamenti App',
      channelDescription: 'Notifiche per aggiornamenti disponibili',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
      color: Color.fromARGB(255, 69, 139, 177),
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notificationsPlugin.show(
      999,
      '🔄 Aggiornamento disponibile',
      'Nuova versione: $newVersion\n$releaseNotes',
      notificationDetails,
      payload: 'update-$newVersion',
    );
  }

  /// Cancella tutte le notifiche
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Cancella una specifica notifica
  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
