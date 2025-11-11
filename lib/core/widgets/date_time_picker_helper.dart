// lib/core/utils/date_time_picker_helper.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DateTimePickerHelper {
  DateTimePickerHelper._();

  // Picker de Fecha
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? now.subtract(const Duration(days: 365)),
      lastDate: lastDate ?? now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryBlue,
            onPrimary: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
          ),
        ),
        child: child!,
      ),
    );
    return picked;
  }

  // Picker de Hora
  static Future<TimeOfDay?> pickTime(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryBlue,
            onPrimary: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
          ),
        ),
        child: child!,
      ),
    );
    return picked;
  }

  // Formatear fecha a String
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Formatear hora a String
  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
