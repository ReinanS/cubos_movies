import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/repositories/genres/genres_repository.dart';
import 'package:cubos_movies/repositories/genres/genres_repository_imp.dart';
import 'package:cubos_movies/service/dio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mock_dio.dart';

void main() {
  DioService _client = MockDio();
  GenresRepository _repository = GenresRepositoryImp(_client);

  group('Genres - ', () {
    test('Should get all Genres', () async {
      final result = await _repository.getGenres();
      late final response;

      result.fold((e) => response = e, (m) => response = m);

      expect(result.isRight(), true);
      expect(response, isA<List<MovieGenre>>());
    });
  });
}
