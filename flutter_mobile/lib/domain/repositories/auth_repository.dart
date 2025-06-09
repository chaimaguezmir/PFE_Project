import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_credentials.dart';
import '../entities/auth/sign_up_result_entity.dart';

abstract class AuthRepository {
  Future<DataState<SignUpResultEntity>> signUp(SignUpCredentials credentials);
  Future<DataState<SignUpResultEntity>> activateAccount(
    ActivateAccountCredentials credentials,
  );
}
