import 'dart:developer';

import 'package:cubos_movies/core/errors/movie.error.dart';
import 'package:cubos_movies/core/tmdb_api.dart';
import 'package:cubos_movies/models/movie_credits.dart';
import 'package:cubos_movies/models/movie_detail_model.dart';
import 'package:cubos_movies/models/movie_response_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository.dart';
import 'package:cubos_movies/service/dio_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MoviesRepositoryImp extends MoviesRepository {
  // SOLID - 5
  // INVERSÃO DO CONTROLE DE DEPENDENCIA
  final DioService _dioService;

  MoviesRepositoryImp(this._dioService);

  @override
  Future<Either<MovieError, MovieResponseModel>> getMovies(int page) async {
    return _getMoviesResponse('/movie/popular?page=$page');
  }

  @override
  Future<Either<MovieError, MovieResponseModel>> getMoviesByname(
      int page, String query) {
    return _getMoviesResponse('/search/movie?page=$page&query=$query');
  }

  @override
  Future<Either<MovieError, MovieResponseModel>> getMovieByGenre(
      int page, int genre) {
    return _getMoviesResponse('/movie/popular?page=$page&with_genres=$genre');
  }

  @override
  Future<Either<MovieError, MovieDetailModel>> getMovieById(int id) async {
    try {
      final response = await _dioService.getDio().get('/movie/$id');
      final model = MovieDetailModel.fromMap(response.data);

      return Right(model);
    } on DioError catch (error) {
      if (error.response == null) {
        return Left(MovieRepositoryError(TmdbApi.kServerError));
      } else {
        return Left(MovieRepositoryError(
            error.response!.data['status_messsage'].toString()));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, MovieResponseModel>> _getMoviesResponse(
      String url) async {
    try {
      final response = await _dioService.getDio().get(url);
      final model = MovieResponseModel.fromMap(response.data);
      log('Status Code = ' + response.statusCode.toString());
      return Right(model);
    } on DioError catch (error) {
      if (error.response?.statusCode == 422) {
        final response = error.response!.data['errors'] as List;
        return Left(MovieRepositoryError(response[0]));
      }

      if (error.response != null) {
        return Left(MovieRepositoryError(
            error.response!.data['status_message'].toString()));
      } else {
        return Left(MovieRepositoryError(TmdbApi.kServerError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  @override
  Future<Either<MovieError, MovieCredits>> getMovieCredits(int id) async {
    try {
      final response = await _dioService.getDio().get('/movie/$id/credits');
      final model = MovieCredits.fromJson(response.data);

      return Right(model);
    } on DioError catch (error) {
      if (error.response == null) {
        return Left(MovieRepositoryError(TmdbApi.kServerError));
      } else {
        return Left(MovieRepositoryError(
            error.response!.data['status_messsage'].toString()));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }
}
