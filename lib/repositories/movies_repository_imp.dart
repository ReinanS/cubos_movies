import 'dart:developer';

import 'package:cubos_movies/core/api.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/repositories/movies_repository.dart';
import 'package:cubos_movies/service/dio_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MoviesRepositoryImp extends MoviesRepository {
  final DioService _dioService;

  MoviesRepositoryImp(this._dioService);

  @override
  Future<Either<MovieError, MovieResponseModel>> getMovies(int page) async {
    return _getMoviesResponse('/movie/popular?page=$page');
  }

  Future<Either<MovieError, MovieResponseModel>> _getMoviesResponse(
      String url) async {
    try {
      final response = await _dioService.getDio().get(url);
      final model = MovieResponseModel.fromMap(response.data);
      log('Status = ' + response.statusCode.toString());

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
}
