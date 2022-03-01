import 'dart:developer';

import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/repositories/genres_repository_imp.dart';
import 'package:cubos_movies/repositories/movie_repository.dart';
import 'package:cubos_movies/service/dio_service_imp.dart';
import 'package:dartz/dartz.dart';

class MovieController {
  final _movieRepository = MovieRepository();

  MovieResponseModel? movieResponseModel;
  MovieError? movieError;
  bool loading = true;

  List<MovieModel> get movies => movieResponseModel?.movies ?? <MovieModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieResponseModel?.totalPages ?? 1;
  int get currentPage => movieResponseModel?.page ?? 1;

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(
      {int page = 1}) async {
    movieError = null;
    final result = await _movieRepository.fetchAllMovies(page);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          movieResponseModel = movie;
        } else {
          movieResponseModel?.page = movie.page;
          movieResponseModel?.movies?.addAll(movie.movies!);
        }
      },
    );

    return result;
  }

  Future<Either<MovieError, MovieResponseModel>> fetchMoviesByGenre(
      {int page = 1, required int genre}) async {
    movieError = null;
    final result = await _movieRepository.fetchMovieByGenre(page, genre);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          movieResponseModel = movie;
        } else {
          movieResponseModel?.page = movie.page;
          movieResponseModel?.movies?.addAll(movie.movies!);
        }
      },
    );

    return result;
  }

  Future<Either<MovieError, MovieResponseModel>> fetchMovieByName(
      {int page = 1, required String query}) async {
    movieError = null;
    final result = await _movieRepository.fetchMoviesByname(page, query);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          movieResponseModel = movie;
        } else {
          movieResponseModel?.page = movie.page;
          movieResponseModel?.movies?.addAll(movie.movies!);
        }
      },
    );

    return result;
  }

  String movieGenderPoster(MovieModel movie, List<MovieGenre> genres) {
    String posterGenres = '';

    for (int index = 0; index < movie.genreIds!.length; index++) {
      if (index == movie.genreIds!.length - 1) {
        posterGenres += genres
            .firstWhere((genre) => genre.id == movie.genreIds![index])
            .name!;
      } else {
        posterGenres += (genres
                .firstWhere((genre) => genre.id == movie.genreIds![index])
                .name! +
            ' - ');
      }
    }

    return posterGenres;
  }
}
