import 'dart:developer';

import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/repositories/genre_repository.dart';
import 'package:cubos_movies/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final _repository = MovieRepository();
  final _genreRepository = GenreRepository();

  test('Should get all popular movies', () async {
    final result = await _repository.fetchAllMovies(1);
    expect(result.isRight(), true);
    expect(result.fold(id, id), isA<MovieResponseModel>());
  });

  test('Should error to get all popular movies', () async {
    final result = await _repository.fetchAllMovies(1000);
    expect(result.isLeft(), true);
    expect(result.fold(id, id), isA<MovieError>());
  });

  test('Should get all popular movies by genre', () async {
    final result = await _repository.fetchMovieByGenre(1, 28);
    expect(result.isRight(), true);
    expect(result.fold(id, id), isA<MovieResponseModel>());
  });

  test('Should error to get all popular movies by genre', () async {
    final result = await _repository.fetchMovieByGenre(1, 15);
    expect(result.isRight(), true);
    expect(result.fold(id, id), isA<MovieResponseModel>());
  });

  test('Should get Movies by name', () async {
    final result = await _repository.fetchMoviesByname(1, 'venom');
    expect(result.isRight(), true);
  });

  test('Should error to get all Movies by name', () async {
    final result = await _repository.fetchMoviesByname(1, '');
    expect(result.isLeft(), true);
    expect(result.fold(id, id), isA<MovieError>());
  });

  test('Should get Movie by ID', () async {
    final result = await _repository.fetchMovieById(703771);
    expect(result.isRight(), true);
    expect(result.fold(id, id), isA<MovieDetailModel>());
  });

  test('Should error to get Movie by ID', () async {
    final result = await _repository.fetchMovieById(1);
    expect(result.isLeft(), true);
    expect(result.fold(id, id), isA<MovieError>());
  });

  test('Should get all Genres', () async {
    final result = await _genreRepository.fetchAllGenres();
    expect(result.isRight(), true);
  });
}
