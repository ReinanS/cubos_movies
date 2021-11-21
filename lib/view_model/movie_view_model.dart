import 'dart:developer';

import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:flutter/cupertino.dart';

class MovieViewModel {
  final _repository;

  MovieViewModel(this._repository);

  final apiResponse =
      ValueNotifier<ApiResponse>(ApiResponse.initial('Empty data'));

  set response(ApiResponse response) => apiResponse.value = response;
  ApiResponse get response => apiResponse.value;

  List<Movie>? _cachedMovies;

  Future<void> fetchMovieData() async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movies = await _repository.fetchMovieList();
      response = ApiResponse.completed(movies);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }

    if (response.status != Status.ERROR)
      _cachedMovies = response.data as List<Movie>;
  }

  Future<void> fetchMovieDetailsData(int movieId) async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movie = await _repository.fetchMovieDetails(movieId);
      response = ApiResponse.completed(movie);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  onChanged(String value) {
    List<Movie> list = _cachedMovies!
        .where(
          (e) => e.toString().toLowerCase().contains(value.toLowerCase()),
        )
        .toList();

    // movies.value = movies.value!,copyWith(listMovies: list);
  }
}
