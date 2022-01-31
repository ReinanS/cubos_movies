import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/repositories/genre_repository.dart';
import 'package:dartz/dartz.dart';

class GenreController {
  final _respository = GenreRepository();

  List<MovieGenre>? _genres;
  MovieError? movieError;
  bool loading = true;

  List<MovieGenre> get genres => _genres ?? <MovieGenre>[];
  int get genresCount => genres.length;
  bool get hasGenres => genresCount != 0;

  Future<Either<MovieError, List<MovieGenre>>> fetchAllGenres() async {
    movieError = null;

    final result = await _respository.fetchAllGenres();

    result.fold(
      (error) => movieError = error,
      (genres) {
        if (_genres == null) {
          _genres = genres;
        } else {
          _genres?.addAll(genres);
        }
      },
    );

    return result;
  }
}
