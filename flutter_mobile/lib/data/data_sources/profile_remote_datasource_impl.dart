// lib/data/data_sources/profile_remote_datasource_impl.dart

import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/profile_remote_datasource.dart';
import 'package:flutter_mobile/data/model/profile/update_profile_request_model.dart';
import 'package:flutter_mobile/data/model/profile/upload_image_response_model.dart';
import 'package:flutter_mobile/data/model/profile/user_profile_response_model.dart';
import 'package:http_parser/http_parser.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  String _getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg';
    }
  }

  @override
  Future<UploadImageResponseModel> uploadProfileImage(String filePath) async {
    try {
      print('📤 Uploading profile image from path: $filePath');

      final fileName = filePath.split('/').last;
      final extension = _getFileExtension(filePath);
      final mimeType = _getMimeType(extension);

      print('📝 File: $fileName, MIME: $mimeType');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        '${ApiEndpoints.baseurl}/profile/image',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('📥 Upload status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadImageResponseModel.fromJson(response.data);
      } else {
        final errorMessage = response.data['message'] ?? 'Upload failed';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('❌ Upload error: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfileResponseModel> getUserProfile() async {
    try {
      print('📥 Fetching user profile');

      final response = await _dio.get('${ApiEndpoints.baseurl}/profile');

      print('✅ Profile fetched: ${response.statusCode}');

      if (response.statusCode == 200) {
        return UserProfileResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch profile: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('❌ Get profile error: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfileResponseModel> updateUserProfile(
    UpdateProfileRequestModel request,
  ) async {
    try {
      print('📤 Updating user profile');
      print('📦 Request data: ${request.toJson()}');

      final response = await _dio.put(
        '${ApiEndpoints.baseurl}/profile',
        data: request.toJson(),
      );

      print('✅ Profile updated: ${response.statusCode}');

      if (response.statusCode == 200) {
        return UserProfileResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update profile: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('❌ Update profile error: $e');
      rethrow;
    }
  }
}
