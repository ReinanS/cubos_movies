import 'package:cubos_movies/core/api.dart';
import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class GenreRepository {
  final Dio _dio = Dio(TmdbApi.kDioOptions);

  Future<Either<MovieError, List<MovieGenre>>> fetchAllGenres() async {
    try {
      final response = await _dio.get('/genre/movie/list');
      final jsonData = response.data['genres'] as List;

      List<MovieGenre> genresList =
          jsonData.map((e) => MovieGenre.fromMap(e)).toList();

      return Right(genresList);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(MovieRepositoryError(
            error.response!.data['status_message'].toString()));
      } else {
        return Left(MovieRepositoryError((TmdbApi.kServerError)));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }
}
