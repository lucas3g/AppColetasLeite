import 'package:dio/dio.dart';

class MeuDio {
  static String get baseUrl => 'google.com';

  static Dio dio() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://elinfo2.jelastic.saveincloud.net/AppColetaLeite',
      connectTimeout: 2000,
    );

    final Dio dio = Dio(options);

    return dio;
  }
}
