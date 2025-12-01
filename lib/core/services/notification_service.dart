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
          },
    );

    await FirebaseMessaging.instance.requestPermission();

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final type = message.data['type'] ?? '';

      if (type == 'sos') {
        final elderId = message.data['elderId'] ?? '';
        final sosId = message.data['sosId'] ?? '';

        if (navigatorKey.currentState != null &&
            navigatorKey.currentState!.mounted) {
          navigatorKey.currentState!.pushNamed(
            AppRoutes.sosAlert,
            arguments: <String, dynamic>{'elderId': elderId, 'sosId': sosId},
          );
        } else {
          // Fallback: mostrar diálogo overlay
          _showSosOverlay(elderId, sosId);
        }

        return;
      }

      showNotification(message);
    });

    String? token = await FirebaseMessaging.instance.getToken();

    _isInitialized = true;
  }

  void _handleNotificationNavigation(
    RemoteMessage message, {
    bool fromTerminated = false,
    bool fromBackground = false,
  }) {
    final type = message.data['type'] ?? '';

    if (type == 'sos') {
      final elderId = message.data['elderId'] ?? '';
      final sosId = message.data['sosId'] ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final delay = fromTerminated
            ? const Duration(milliseconds: 500)
            : Duration.zero;
        Future.delayed(delay, () {
          navigatorKey.currentState?.pushNamed(
            AppRoutes.sosAlert,
            arguments: <String, dynamic>{'elderId': elderId, 'sosId': sosId},
          );
        });
      });
      return;
    }

    String intakeId =
        message.data['intakeId'] ?? message.data['scheduleId'] ?? '';

    String origin = fromTerminated
        ? 'terminated'
        : (fromBackground ? 'background' : 'foreground');

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

    final type = message.data['type'] ?? '';

    if (type == 'sos') {
      return;
    }

    String intakeId =
        message.data['intakeId'] ?? message.data['scheduleId'] ?? '';

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel_id', // id
      'Medication Alerts', // name
      description: 'Notificaciones de medicamentos y recordatorios',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel_id',
          'Medication Alerts',
          channelDescription: 'Notificaciones de medicamentos y recordatorios',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      message.notification?.title ?? 'Recordatorio',
      message.notification?.body,
      platformDetails,
      payload: intakeId,
    );
  }
}

void _showSosOverlay(String elderId, String sosId) {
  // Crear overlay para mostrar SOS incluso sin Navigator listo
  WidgetsBinding.instance.addPostFrameCallback((_) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 60, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  '🚨 ALERTA SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Elder: $elderId', style: TextStyle(color: Colors.white)),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                    overlayEntry?.remove();
                    // Intentar navegar una vez más
                    if (navigatorKey.currentState?.mounted == true) {
                      navigatorKey.currentState!.pushNamed(
                        AppRoutes.sosAlert,
                        arguments: <String, dynamic>{
                          'elderId': elderId,
                          'sosId': sosId,
                        },
                      );
                    }
                  },
                  child: Text('Aceptar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(WidgetsBinding.instance.rootElement!)?.insert(overlayEntry!);

    // Auto cerrar después de 10s
    Future.delayed(Duration(seconds: 10), () => overlayEntry?.remove());
  });
}
