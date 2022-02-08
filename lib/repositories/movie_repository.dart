import 'dart:developer';

import 'package:cubos_movies/core/api.dart';
import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MovieRepository {
  final Dio _dio = Dio(TmdbApi.kDioOptions);

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(int page) {
    return _fetchMovieResponse('/movie/popular?page=$page');
  }

  Future<Either<MovieError, MovieResponseModel>> fetchMoviesByname(
      String query) async {
    return await _fetchMovieResponse('/search/movie?query=$query');
  }

  Future<Either<MovieError, MovieResponseModel>> fetchMovieByGenre(
      int page, int genre) {
    return _fetchMovieResponse('/movie/popular?page=$page&with_genres=$genre');
  }

  Future<Either<MovieError, MovieResponseModel>> _fetchMovieResponse(
      String url) async {
    try {
      final response = await _dio.get(url);
      final model = MovieResponseModel.fromMap(response.data);
      log('Movies = ' + response.statusCode.toString());

      return Right(model);
    } on DioError catch (error) {
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

  Future<Either<MovieError, MovieDetailModel>> fetchMovieById(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      final model = MovieDetailModel.fromMap(response.data);
      log(response.statusCode.toString());

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
