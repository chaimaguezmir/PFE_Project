// lib/data/data_sources/profile_remote_datasource.dart

import 'package:flutter_mobile/data/model/profile/upload_image_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UploadImageResponseModel> uploadProfileImage(String filePath);
}

