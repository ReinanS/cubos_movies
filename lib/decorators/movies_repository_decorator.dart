import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/models/movie_credits.dart';
import 'package:cubos_movies/models/movie_detail_model.dart';
import 'package:cubos_movies/models/movie_response_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository.dart';
import 'package:dartz/dartz.dart';

class MoviesRepositoryDecorator implements MoviesRepository {
  final MoviesRepository _moviesRepository;
  MoviesRepositoryDecorator(this._moviesRepository);

  @override
  Future<Either<MovieError, MovieResponseModel>> getMovies(int page) async {
    return await _moviesRepository.getMovies(page);
  }

  @override
  Future<Either<MovieError, MovieResponseModel>> getMovieByGenre(
      int page, int genre) {
    return _moviesRepository.getMovieByGenre(page, genre);
  }

  @override
  Future<Either<MovieError, MovieDetailModel>> getMovieById(int id) {
    return _moviesRepository.getMovieById(id);
  }

  @override
  Future<Either<MovieError, MovieResponseModel>> getMoviesByname(
      int page, String query) {
    return _moviesRepository.getMoviesByname(page, query);
  }

  @override
  Future<Either<MovieError, MovieCredits>> getMovieCredits(int id) {
    return _moviesRepository.getMovieCredits(id);
  }
}
