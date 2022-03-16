import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/models/movie_credits.dart';
import 'package:cubos_movies/models/movie_detail_model.dart';
import 'package:cubos_movies/models/movie_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class MoviesRepository {
  Future<Either<MovieError, MovieResponseModel>> getMovies(int page);
  Future<Either<MovieError, MovieResponseModel>> getMoviesByname(
      int page, String query);
  Future<Either<MovieError, MovieResponseModel>> getMovieByGenre(
      int page, int genre);
  Future<Either<MovieError, MovieDetailModel>> getMovieById(int id);
  Future<Either<MovieError, MovieCredits>> getMovieCredits(int id);
}
