import 'dart:developer';

import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:flutter/cupertino.dart';

class MovieDetailViewModel {
  MovieRepository _repository;

  MovieDetailViewModel(this._repository);

  final apiResponse =
      ValueNotifier<ApiResponse>(ApiResponse.initial('Empty data'));

  set response(ApiResponse response) => apiResponse.value = response;
  ApiResponse get response => apiResponse.value;

  Future<void> fetchMovieDetailsData(int movieId) async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final movie = await _repository.fetchMovieDetails(movieId);
      response = ApiResponse.completed(movie);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      log(e.toString());
    }
  }
}
