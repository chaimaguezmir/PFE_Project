
import 'package:flutter_mobile/domain/entities/auth/sign_up_result_entity.dart';

class SignUpResultModel extends SignUpResultEntity {
  SignUpResultModel({required super.message});

  factory SignUpResultModel.fromJson(Map<String, dynamic> json) {
    return SignUpResultModel(message: json['message'] as String);
  }
}
