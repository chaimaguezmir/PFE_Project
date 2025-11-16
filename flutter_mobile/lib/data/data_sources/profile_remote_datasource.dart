import 'package:flutter_mobile/data/model/profile/update_profile_request_model.dart';
import 'package:flutter_mobile/data/model/profile/upload_image_response_model.dart';
import 'package:flutter_mobile/data/model/profile/user_profile_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UploadImageResponseModel> uploadProfileImage(String filePath);
  Future<UserProfileResponseModel> getUserProfile();
  Future<UserProfileResponseModel> updateUserProfile(UpdateProfileRequestModel request);
}