import 'package:flutter_mobile/data/model/reminder/simple_create_reminder_request_model.dart';
import 'package:flutter_mobile/data/model/reminder/simple_reminder_response_model.dart';

abstract class SimpleReminderRemoteDataSource {
  Future<List<SimpleReminderResponseModel>> createReminders(
    SimpleCreateReminderRequestModel request,
  );
}

