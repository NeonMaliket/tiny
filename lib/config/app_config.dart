import 'package:dio/dio.dart';

const String baseUrl = 'http://127.0.0.1:8080/api';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ),
);
