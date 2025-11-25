import 'package:heraguard_frontend/core/services/notification_service.dart';
import 'package:heraguard_frontend/features/medications/domain/entities/medication.dart';

class MedicationNotificationScheduler {
  final NotificationService _notificationService = NotificationService();

  Future<void> scheduleMedicationNotifications(Medication medication) async {
    await _notificationService.initialize();
    await _notificationService.requestPermissions();

    final List<DateTime> allScheduledDates = _calculateScheduledDates(
      medication,
    );

    int notificationId = _generateNotificationId(medication.medicationId);

    for (var scheduledDate in allScheduledDates) {
      if (scheduledDate.isAfter(DateTime.now())) {
        final fiveMinBefore = scheduledDate.subtract(
          const Duration(minutes: 5),
        );
        if (fiveMinBefore.isAfter(DateTime.now())) {
          await _notificationService.scheduleNotification(
            id: notificationId++,
            title: '⏰ Recordatorio: ${medication.name}',
            body: 'Toma tu medicamento en 5 minutos - ${medication.dosage}',
            scheduledDate: fiveMinBefore,
            payload: medication.medicationId,
          );
        }

        await _notificationService.scheduleNotification(
          id: notificationId++,
          title: '💊 ${medication.name}',
          body: 'Es hora de tomar tu medicamento - ${medication.dosage}',
          scheduledDate: scheduledDate,
          payload: medication.medicationId,
        );
      }
    }
  }

  List<DateTime> _calculateScheduledDates(Medication medication) {
    final List<DateTime> dates = [];
    DateTime currentDate = medication.startDate;
    final endDate = medication.startDate.add(
      Duration(days: medication.duration),
    );

    while (currentDate.isBefore(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(hours: medication.frequency));
    }

    return dates;
  }

  int _generateNotificationId(String medicationId) {
    return medicationId.substring(0, 8).hashCode.abs();
  }

  Future<void> cancelMedicationNotifications(String medicationId) async {
    final baseId = _generateNotificationId(medicationId);

    await _notificationService.cancelNotificationRange(baseId, baseId + 1000);
  }

  Future<void> scheduleOneDayBeforeReminder(Medication medication) async {
    final oneDayBefore = medication.startDate.subtract(const Duration(days: 1));

    if (oneDayBefore.isAfter(DateTime.now())) {
      final id = _generateNotificationId(
        '${medication.medicationId}_daybefore',
      );

      await _notificationService.scheduleNotification(
        id: id,
        title: '📢 Recordatorio de medicamento',
        body: 'Mañana comienza el tratamiento de ${medication.name}',
        scheduledDate: oneDayBefore,
        payload: medication.medicationId,
      );
    }
  }
}
