import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';

abstract class SimpleReminderRepository {
  Future<DataState<List<SimpleReminderEntity>>> createReminders(
    SimpleCreateReminderEntity reminderRequest,
  );
}

