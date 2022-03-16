import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/models/movie_credits.dart';
import 'package:cubos_movies/models/movie_detail_model.dart';
import 'package:cubos_movies/models/movie_response_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository.dart';
import 'package:cubos_movies/repositories/movies/movies_repository_imp.dart';
import 'package:cubos_movies/service/dio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../mock_dio.dart';

void main() {
  DioService _client = MockDio();
  MoviesRepository _repository = MoviesRepositoryImp(_client);

  group('Movies By Genre - ', () {
    test('Should get all popular movies', () async {
      final result = await _repository.getMovieByGenre(1, 28);
      late final response;

      result.fold((e) => response = e, (m) => response = m);

      expect(result.isRight(), true);
      expect(response, isA<MovieResponseModel>());
    });

    test('Should error to get all popular movies', () async {
      final result = await _repository.getMovieByGenre(1000, 15);
      late final response;

      result.fold((e) => response = e, (m) => response = m);
      expect(result.isLeft(), true);
      expect(response, isA<MovieError>());
    });
  });

  group('Movies By ID - ', () {
    test('Sucess to get movie', () async {
      final result = await _repository.getMovieById(703771);
      late final response;

      result.fold((e) => response = e, (m) => response = m);

      expect(result.isRight(), true);
      expect(response, isA<MovieDetailModel>());
    });

    test('Error to get movie', () async {
      final result = await _repository.getMovieById(1);
      late final response;

      result.fold((e) => response = e, (m) => response = m);
      expect(result.isLeft(), true);
      expect(response, isA<MovieError>());
    });
  });

  group('Movie Credits - ', () {
    test('Sucess to get credits', () async {
      final result = await _repository.getMovieCredits(566525);
      late final response;

      result.fold((e) => response = e, (m) => response = m);

      expect(result.isRight(), true);
      expect(response, isA<MovieCredits>());
    });

    test('Error to get credits', () async {
      final result = await _repository.getMovieCredits(1);
      late final response;

      result.fold((e) => response = e, (m) => response = m);
      expect(result.isLeft(), true);
      expect(response, isA<MovieError>());
    });
  });
}
