import 'dart:developer';

import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

class MovieController {
  final MoviesRepository _movieRepository;

  MovieController(this._movieRepository);

  final moviesResponseApi = ValueNotifier<MovieResponseModel?>(null);
  final loadingApi = ValueNotifier<bool>(false);
  final movieErrorApi = ValueNotifier<MovieError?>(null);

  set _movieResponseModel(MovieResponseModel? movies) =>
      moviesResponseApi.value = movies;
  set _loading(bool bool) => loadingApi.value = bool;
  set _movieError(MovieError? error) => movieErrorApi.value = error;

  MovieResponseModel? get movieResponseModel => moviesResponseApi.value;
  bool get loading => loadingApi.value;
  MovieError? get movieError => movieErrorApi.value;

  List<MovieModel> get movies => movieResponseModel?.movies ?? <MovieModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieResponseModel?.totalPages ?? 1;
  int get currentPage => movieResponseModel?.page ?? 1;

  Future<void> initialize(int genre) async {
    _loading = true;
    await this.fetchMoviesByGenre(genre: genre);
    _loading = false;
  }

  Future<Either<MovieError, MovieResponseModel>> fetchMoviesByGenre(
      {int page = 1, required int genre}) async {
    _movieError = null;
    final result = await _movieRepository.getMovieByGenre(page, genre);
    result.fold(
      (error) => _movieError = error,
      (movie) {
        if (movieResponseModel == null) {
          _movieResponseModel = movie;
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
    _movieError = null;
    _loading = true;
    final result = await _movieRepository.getMoviesByname(page, query);
    result.fold(
      (error) {
        _movieError = error;
      },
      (movie) {
        _movieResponseModel = movie;
        movieResponseModel?.page = movie.page;
      },
    );

    _loading = false;
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
