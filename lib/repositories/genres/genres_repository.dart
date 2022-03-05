import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:dartz/dartz.dart';

abstract class GenresRepository {
  Future<Either<MovieError, List<MovieGenre>>> getGenres();
}
