import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/model/prescription/reminder_model.dart';
import 'reminder_remote_data_source.dart';

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final Dio _dio;

  ReminderRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ReminderModel>> getRemindersWithMedications() async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseurl}/reminders/with-medications',
      );
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => ReminderModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch reminders: \\${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getRemindersWithMedications: \\${e.message}');
      print('Status code: \\${e.response?.statusCode}');
      print('Response data: \\${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getRemindersWithMedications: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/reminders/with-medications'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
