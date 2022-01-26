import 'package:cubos_movies/core/api.dart';
import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/model/movie_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MovieRepository {
  final Dio _dio = Dio(kDioOptions);

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(
      int page) async {
    try {
      final response = await _dio.get('/movie/popular?page=$page');
      final model = MovieResponseModel.fromJson(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response == null) {
        return Left(MovieRepositoryError(kServerError));
      }

      return Left(MovieRepositoryError(error.response?.data['status_message']));
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, MovieDetailModel>> fetchMovieById(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      final model = MovieDetailModel.fromJson(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response == null) {
        return Left(MovieRepositoryError(kServerError));
      }

      return Left(
          MovieRepositoryError(error.response?.data['status_messsage']));
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }
}
