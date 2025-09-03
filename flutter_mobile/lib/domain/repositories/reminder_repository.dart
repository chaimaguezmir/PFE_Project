import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';

abstract class ReminderRepository {
  Future<DataState<List<ReminderEntity>>> getRemindersWithMedications();
}
