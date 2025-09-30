// lib/domain/repositories/profile_repository.dart

import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/profile/upload_image_entity.dart';

abstract class ProfileRepository {
  Future<DataState<UploadImageEntity>> uploadProfileImage(String filePath);
}

