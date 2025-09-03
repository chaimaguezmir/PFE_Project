import 'package:flutter_mobile/data/model/prescription/reminder_model.dart';

abstract class ReminderRemoteDataSource {
  Future<List<ReminderModel>> getRemindersWithMedications();
}

