import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_mobile/core/services/navigation_service.dart'; // ← si tu veux rediriger

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.dio, this.prefs);

  final Dio dio;
  final SharedPreferences prefs;

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

      final refreshToken = prefs.getString('refreshToken');
      if (refreshToken == null) {
        print('[AuthInterceptor] No refresh token found');
        return handler.next(err);
      }

      try {
        final response = await dio.post(
          '${ApiEndpoints.baseurl}/auth/refreshtoken',
          data: {'refreshToken': refreshToken},
        );

        print('[AuthInterceptor] Refresh response: ${response.data}');

        final newToken = response.data['accessToken'];
        if (newToken == null || newToken.isEmpty) {
          print('[AuthInterceptor] Invalid or missing accessToken');
          await _handleLogout();
          return handler.reject(err);
        }

        await prefs.setString('token', newToken);
        print('[AuthInterceptor] Token refreshed successfully');

        //  Rejouer la requête échouée avec le nouveau token
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
        await _handleLogout();
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  Future<void> _handleLogout() async {
    await prefs.remove('token');
    await prefs.remove('refresh_token');

    // TODO: redirection vers la page de connexion

  }
}
