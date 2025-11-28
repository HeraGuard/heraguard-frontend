import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            String? intakeId = notificationResponse.payload;
            if (intakeId != null && intakeId.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigatorKey.currentState?.pushNamed(
                  AppRoutes.medicationIntake,
                  arguments: intakeId,
                );
              });
            }
            print('Notificación tocada: ${notificationResponse.payload}');
          },
    );

    // Pedir permisos para iOS y Android 13+
    await FirebaseMessaging.instance.requestPermission();

    // Configura presentación de notificaciones en primer plano (iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    //Todo
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationNavigation(initialMessage, fromTerminated: true);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message, fromBackground: true);
    });

    // Escuchar mensajes en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        'Mensaje push recibido: ${message.notification?.title} - ${message.notification?.body}',
      );
      showNotification(message);
    });

    // Obtén el FCM token (opcional)
    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');

    _isInitialized = true;
  }

  void _handleNotificationNavigation(
    RemoteMessage message, {
    bool fromTerminated = false,
    bool fromBackground = false,
  }) {
    String intakeId =
        message.data['intakeId'] ?? message.data['scheduleId'] ?? '';

    String origin = fromTerminated
        ? 'terminated'
        : (fromBackground ? 'background' : 'foreground');
    print('[DEBUG] Navegando desde $origin con intakeId: $intakeId');

    if (intakeId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Delay extra si viene de terminated para asegurar que el árbol esté listo
        final delay = fromTerminated
            ? Duration(milliseconds: 500)
            : Duration.zero;
        Future.delayed(delay, () {
          navigatorKey.currentState?.pushNamed(
            AppRoutes.medicationIntake,
            arguments: intakeId,
          );
        });
      });
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    if (!_isInitialized) return;

    String intakeId =
        message.data['intakeId'] ?? message.data['scheduleId'] ?? '';

    print('[DEBUG]intakeId recibido: $intakeId');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel_id',
          'Default Channel',
          channelDescription: 'Canal para notificaciones por defecto',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: intakeId,
    );
  }
}
