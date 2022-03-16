import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/models/movie_genre.dart';
import 'package:cubos_movies/repositories/genres/genres_repository.dart';
import 'package:flutter/widgets.dart';

class GenreController {
  final GenresRepository _genreRespository;

  GenreController(this._genreRespository) {
    this.fetchAllGenres();
  }

  ValueNotifier<List<MovieGenre>> genresApi =
      ValueNotifier<List<MovieGenre>>([]);
  ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  ValueNotifier<MovieError?> movieErrorApi = ValueNotifier<MovieError?>(null);

  MovieError? get movieError => movieErrorApi.value;
  List<MovieGenre> get genres => genresApi.value;

  int get genresCount => genres.length;
  bool get hasGenres => genresCount != 0;

  void fetchAllGenres() async {
    movieErrorApi.value = null;
    loading.value = true;

    final result = await _genreRespository.getGenres();

    result.fold(
      (error) => movieErrorApi.value = error,
      (g) => genresApi.value.addAll(g),
    );

    loading.value = false;
  }
}
