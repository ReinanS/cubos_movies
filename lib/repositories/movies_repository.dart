import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class MoviesRepository {
  Future<Either<MovieError, MovieResponseModel>> getMovies(int page);
}
