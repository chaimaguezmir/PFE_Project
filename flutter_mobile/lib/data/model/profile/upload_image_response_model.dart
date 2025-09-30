// lib/data/model/profile/upload_image_response_model.dart

import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/domain/entities/profile/upload_image_entity.dart';

class UploadImageResponseModel extends UploadImageEntity {
  const UploadImageResponseModel({
    required super.message,
    required super.imageUrl,
  });

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing upload response: $json');

      // The API returns: {"message": "Profile image uploaded successfully: http://..."}
      final message = json['message'] as String? ?? '';
      print('📝 Message: $message');

      // Extract image URL from message
      String imageUrl = '';
      if (message.contains(': ')) {
        final parts = message.split(': ');
        if (parts.length > 1) {
          imageUrl = parts[1].trim();
        }
      }

      print('🖼️ Extracted image URL: $imageUrl');

      if (imageUrl.isEmpty) {
        print('⚠️ Warning: Could not extract image URL from message');
        // Try to get from a direct field if available
        if (json.containsKey('imageUrl')) {
          imageUrl = json['imageUrl'] as String? ?? '';
          print('🔄 Found imageUrl in direct field: $imageUrl');
        }
      }

      // If the URL is relative (starts with /), prepend the base URL
      if (imageUrl.isNotEmpty && imageUrl.startsWith('/')) {
        // Extract base URL without /api suffix
        final baseUrl = ApiEndpoints.baseurl.replaceAll('/api', '');
        imageUrl = '$baseUrl$imageUrl';
        print('🔗 Converted relative URL to absolute: $imageUrl');
      }

      return UploadImageResponseModel(
        message: message,
        imageUrl: imageUrl,
      );
    } catch (e) {
      print('❌ Error parsing upload response: $e');
      print('📦 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'imageUrl': imageUrl,
  };
}