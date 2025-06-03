import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/sign_up_credentials.dart';

import '../entities/sign_up_result_entity.dart';

abstract class AuthRepository {
  Future<DataState<SignUpResultEntity>> signUp(SignUpCredentials credentials);
}
