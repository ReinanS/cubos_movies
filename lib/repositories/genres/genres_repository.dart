import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/models/movie_genre.dart';
import 'package:dartz/dartz.dart';

abstract class GenresRepository {
  Future<Either<MovieError, List<MovieGenre>>> getGenres();
}
