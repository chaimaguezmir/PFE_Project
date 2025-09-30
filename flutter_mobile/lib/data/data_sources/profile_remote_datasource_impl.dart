// lib/data/data_sources/profile_remote_datasource_impl.dart

import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/profile_remote_datasource.dart';
import 'package:flutter_mobile/data/model/profile/upload_image_response_model.dart';
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
        return 'image/jpeg'; // Default fallback
    }
  }

  @override
  Future<UploadImageResponseModel> uploadProfileImage(String filePath) async {
    try {
      print('📤 Uploading profile image from path: $filePath');

      // Extract filename and extension
      final fileName = filePath.split('/').last;
      final extension = _getFileExtension(filePath);
      final mimeType = _getMimeType(extension);

      print('📝 File details:');
      print('  - Filename: $fileName');
      print('  - Extension: $extension');
      print('  - MIME Type: $mimeType');

      // Create multipart file with explicit content type
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      print('✅ FormData created successfully');

      // Upload with proper headers (token is added by AuthInterceptor)
      final response = await _dio.post(
        '${ApiEndpoints.baseurl}/profile/image',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) {
            // Accept both 200 and 201 as success
            return status != null && status < 500;
          },
        ),
      );

      print('📥 Upload response status: ${response.statusCode}');
      print('📦 Upload response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadImageResponseModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        final errorMessage = response.data['message'] ?? 'Invalid request';
        print('❌ Bad request: $errorMessage');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
          type: DioExceptionType.badResponse,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to upload profile image: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException in uploadProfileImage:');
      print('  - Message: ${e.message}');
      print('  - Type: ${e.type}');
      print('  - Status code: ${e.response?.statusCode}');
      print('  - Response data: ${e.response?.data}');
      rethrow;
    } catch (e, stackTrace) {
      print('❌ Unexpected error in uploadProfileImage: $e');
      print('📚 Stack trace: $stackTrace');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/profile/image'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}