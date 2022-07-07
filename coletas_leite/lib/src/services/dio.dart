import 'package:dio/dio.dart';

class MeuDio {
  static String get baseUrl => 'google.com';
  static String get baseURLAPP =>
      'http://elinfo2.jelastic.saveincloud.net/AppColetaLeite';
  static String get baseURLLicense => 'http://18.228.152.149:9000';

  static Dio dio() {
    BaseOptions options = BaseOptions(
      connectTimeout: 5000,
    );

    final Dio dio = Dio(options);

    return dio;
  }
}
