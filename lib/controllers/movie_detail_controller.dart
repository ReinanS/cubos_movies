import 'package:cubos_movies/errors/movie.error.dart';
import 'package:cubos_movies/model/%20movie_credits.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/model/production_company_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository.dart';
import 'package:flutter/widgets.dart';

class MovieDetailController {
  final MoviesRepository _movieRepository;

  MovieDetailController(this._movieRepository);

  final movieResponseApi = ValueNotifier<MovieDetailModel?>(null);
  final movieCreditsResponseApi = ValueNotifier<MovieCredits?>(null);
  final loadingApi = ValueNotifier<bool>(false);
  final movieErrorApi = ValueNotifier<MovieError?>(null);

  set _movieResponseApi(MovieDetailModel? movie) =>
      movieResponseApi.value = movie;
  set _movieCreditsResponseApi(MovieCredits? credits) =>
      movieCreditsResponseApi.value = credits;
  set _loading(bool loading) => loadingApi.value = loading;
  set _movieError(MovieError? error) => movieErrorApi.value = error;

  MovieDetailModel? get movieDetail => movieResponseApi.value;
  MovieCredits? get movieCredits => movieCreditsResponseApi.value;
  bool get loading => loadingApi.value;
  MovieError? get movieError => movieErrorApi.value;

  void fetchMovieById(int id) async {
    _movieError = null;
    _loading = true;
    final result = await _movieRepository.getMovieById(id);

    result.fold(
      (error) => _movieError = error,
      (detail) => _movieResponseApi = detail,
    );
    _loading = false;
  }

  void fetchMovieCredits(int id) async {
    _movieError = null;
    _loading = true;
    final result = await _movieRepository.getMovieCredits(id);

    result.fold(
      (error) => _movieError = error,
      (credits) => _movieCreditsResponseApi = credits,
    );
    _loading = false;
  }

  String getDuration(int duration) {
    if (duration == 0) {
      return '-';
    }

    Duration d = Duration(minutes: duration);
    List<String> time = d.toString().split(':');
    return '${time[0]}h ${time[1]} min';
  }

  String getListString(List<String> list) {
    String str = '';

    for (int index = 0; index < list.length; index++) {
      if (index == list.length - 1) {
        str += list[index];
      } else {
        str += list[index] + ', ';
      }
    }

    return str;
  }

  List<String> getCompanyName(List<ProductionCompanyModel> listCompany) {
    List<String> list = [];

    listCompany.forEach((company) {
      list.add(company.name!);
    });

    return list;
  }

  List<String> getDirectorName(List<Crew> crew) {
    List<String> list = [];

    List<Crew> crewList = [];

    // FILTRO
    crewList = crew.where((c) => c.job == 'Director').toList();

    // ADICIONA À LISTA
    crewList.forEach((c) {
      list.add(c.name);
    });

    return list;
  }

  List<String> getCastName(List<Cast> cast) {
    List<String> list = [];

    // ADICIONA À LISTA
    cast.forEach((c) {
      list.add(c.name);
    });

    return list;
  }
}
