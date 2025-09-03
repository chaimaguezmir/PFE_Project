import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';
import 'package:flutter_mobile/domain/repositories/reminder_repository.dart';
import 'package:flutter_mobile/data/data_sources/reminder_remote_data_source.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDataSource remoteDataSource;

  ReminderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<ReminderEntity>>> getRemindersWithMedications() async {
    try {
      final result = await remoteDataSource.getRemindersWithMedications();
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('An unexpected error occurred: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data.toString() ?? 'Unknown Dio error';
    }
    return e.message ?? 'Unknown Dio error';
  }
}
