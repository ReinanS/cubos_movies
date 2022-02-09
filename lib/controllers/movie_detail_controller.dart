import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class MovieDetailController {
  final _repository = MovieRepository();

  MovieDetailModel? movie;
  MovieError? movieError;

  bool loading = true;

  Future<Either<MovieError, MovieDetailModel>> fetchMovieById(int id) async {
    movieError = null;
    final result = await _repository.fetchMovieById(id);

    result.fold(
      (error) => movieError = error,
      (detail) => movie = detail,
    );

    return result;
  }

  // movie credits

}
