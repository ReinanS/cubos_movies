import 'dart:developer';

import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:flutter/cupertino.dart';

class GenreViewModel {
  final _repository;

  GenreViewModel(this._repository);

  final apiResponse =
      ValueNotifier<ApiResponse>(ApiResponse.initial('Empty data'));

  set response(ApiResponse response) => apiResponse.value = response;
  ApiResponse get response => apiResponse.value;

  List<MovieGenre>? _cachedGenres;

  Future<void> fetchGenresList() async {
    response = ApiResponse.loading('Fetching movie data');

    try {
      final genres = await _repository.fetchGenreList();
      response = ApiResponse.completed(genres);
    } catch (e) {
      response = ApiResponse.error(e.toString());
      print(e);
    }
  }
}
