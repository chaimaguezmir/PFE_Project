import 'package:flutter_mobile/domain/entities/auth/check_reset_code_result_entity.dart';

class CheckResetCodeResultModel {
  CheckResetCodeResultModel({required this.message});

  factory CheckResetCodeResultModel.fromJson(Map<String, dynamic> json) {
    return CheckResetCodeResultModel(message: json['message'] ?? '');
  }

  final String message;

  CheckResetCodeResultEntity toEntity() {
    return CheckResetCodeResultEntity(message: message);
  }
}
