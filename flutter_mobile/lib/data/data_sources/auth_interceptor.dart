import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {

  AuthInterceptor(this.prefs);
  final SharedPreferences prefs;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Content-Type'] = 'application/json';

    return super.onRequest(options, handler);
  }
}