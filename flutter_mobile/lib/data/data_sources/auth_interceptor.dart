import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.dio, this.prefs);
  final SharedPreferences prefs;
  final Dio dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[AuthInterceptor] onRequest: ${options.method} ${options.path}');
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      print('[AuthInterceptor] Adding Authorization header');
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Content-Type'] = 'application/json';

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print(
      '[AuthInterceptor] onError: ${err.response?.statusCode} ${err.requestOptions.path}',
    );
    if (err.response?.statusCode == 401) {
      print('[AuthInterceptor] 401 detected, trying to refresh token');
      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken == null) {
        print('[AuthInterceptor] No refresh token found');
        return handler.next(err);
      }

      try {
        final response = await dio.post(
          '${ApiEndpoints.baseurl}/auth/refreshtoken',
          data: {'refreshToken': refreshToken},
        );
        print('[AuthInterceptor] Token refreshed successfully');

        final newToken = response.data['accessToken'];
        await prefs.setString('token', newToken);

        // Replay the original request with the new token
        final clonedRequest = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: {
              ...err.requestOptions.headers,
              'Authorization': 'Bearer $newToken',
            },
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        return handler.resolve(clonedRequest);
      } catch (e) {
        print('[AuthInterceptor] Token refresh failed: $e');
        await prefs.remove('token');
        await prefs.remove('refresh_token');
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }
}
