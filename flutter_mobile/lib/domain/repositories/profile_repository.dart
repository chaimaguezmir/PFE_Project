import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/profile/upload_image_entity.dart';
import 'package:flutter_mobile/domain/entities/profile/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<DataState<UploadImageEntity>> uploadProfileImage(String filePath);
  Future<DataState<UserProfileEntity>> getUserProfile();
  Future<DataState<UserProfileEntity>> updateUserProfile(
    UpdateProfileEntity profile,
  );
}
