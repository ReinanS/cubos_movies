import 'package:cubos_movies/service/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements DioService {
  @override
  Dio getDio() {
    return Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: 5000,
        receiveTimeout: 3000,
        contentType: 'application/json;charset=utf-8',
        headers: {'Authorization': 'Bearer $kApiKey'},
      ),
    );
  }

  final kApiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiN2VjNDE4NTNiZTI4NTE0OTQ3YmM2ODRiMTYxMDAwMSIsInN1YiI6IjYxOTAxYzgxZDc1YmQ2MDA2NDQwNjExNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rIfcRo5grKLiuXKHszbsowp0N8LYrtDgKF4Of7v6svk';

  static final kBaseUrl = 'https://api.themoviedb.org/3';
}
