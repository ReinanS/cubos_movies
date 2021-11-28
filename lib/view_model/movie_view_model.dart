import 'dart:developer';

import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:flutter/cupertino.dart';

class MovieViewModel {
  MovieRepository _repository;

  MovieViewModel(this._repository);

  final apiResponse =
      ValueNotifier<ApiResponse>(ApiResponse.initial('Empty data'));

  set response(ApiResponse response) => apiResponse.value = response;
  ApiResponse get response => apiResponse.value;

  Future<void> fetchMovieData({int page = 1}) async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movie = await _repository.fetchAllMovies(page);
      response = ApiResponse.completed(movie.movies);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }

  Future<void> fetchMovieByGenreData({int page = 1, required int genre}) async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movie = await _repository.fetchMoviesByGenre(page, genre);
      response = ApiResponse.completed(movie.movies);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
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
}
