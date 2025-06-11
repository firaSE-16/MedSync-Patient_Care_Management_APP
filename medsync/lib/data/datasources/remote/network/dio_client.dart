import 'package:dio/dio.dart';
import 'package:medsync/core/constants/api_constants.dart';
import 'package:medsync/core/constants/app_constants.dart';
import 'package:medsync/core/services/shared_preferences_service.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  DioClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SharedPreferencesService.getString(AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: 'Connection timeout. Please check your internet connection.',
            ),
          );
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
