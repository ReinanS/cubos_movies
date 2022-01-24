import 'dart:developer';

import 'package:cubos_movies/model/%20movie_credits.dart';
import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/model/production_company.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:cubos_movies/view/utils/constansts.dart';
import 'package:cubos_movies/view/utils/utils.dart';
import 'package:cubos_movies/view/widgets/description_text.dart';
import 'package:cubos_movies/view/widgets/genre_box.dart';
import 'package:cubos_movies/view/widgets/info_box.dart';
import 'package:cubos_movies/view_model/details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieDetailViewModel movieDetailViewModel =
      MovieDetailViewModel(MovieRepository());

  final MovieDetailViewModel creditsViewModel =
      MovieDetailViewModel(MovieRepository());

  final currencyFormat = new NumberFormat('###,###,###');

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    movieDetailViewModel.fetchMovieDetailsData(widget.movieId);
    movieDetailViewModel.apiResponse.addListener(() {
      setState(() {});
    });

    creditsViewModel.fetchMovieCreditsData(widget.movieId);
    creditsViewModel.apiResponse.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _background(
          _body(),
        ));
  }

  Widget _body() {
    return Container();
  }

  Widget _background(Widget body) {
    ApiResponse apiMovieDetailsResponse = movieDetailViewModel.response;
    ApiResponse apiCreditsResponse = creditsViewModel.response;

    if ((apiMovieDetailsResponse.status == Status.LOADING) ||
        (apiCreditsResponse.status == Status.LOADING)) {
      return Center(child: CircularProgressIndicator());
    }

    if ((apiMovieDetailsResponse.status == Status.COMPLETED) ||
        (apiCreditsResponse.status == Status.COMPLETED)) {
      return buildMovieDetail(apiMovieDetailsResponse, apiCreditsResponse);
    }

    if ((apiMovieDetailsResponse.status == Status.ERROR) ||
        (apiCreditsResponse.status == Status.ERROR)) {
      return Center(child: Text('Please try again Later !!'));
    }

    return Center(child: Text('Search the Movie'));
  }

  Widget buildMovieDetail(
      ApiResponse apiMovieDetailResponse, ApiResponse apiCreditResponse) {
    MovieDetailModel? movie = apiMovieDetailResponse.data as MovieDetailModel?;
    MovieCredits? credits = apiCreditResponse.data as MovieCredits?;

    Size deviceSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: deviceSize.height * 0.6,
            color: AppColors.whiteSmoke,
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButton(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 25),
                  width: double.infinity,
                  height: deviceSize.height * 0.7,
                  child: Center(
                    child: Hero(
                      tag: widget.movieId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: TmdbConstants.imageBase + movie!.backdropPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            movie.voteAverage.toString(),
                            style: TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            ' / 10',
                            style: TextStyle(
                              color: AppColors.mediumGrey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.04),
                  child: Text(
                    movie.title.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textDark),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.06),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Titulo original: ",
                          style: TextStyle(
                            color: AppColors.basicGrey,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: movie.originalTitle,
                          style: TextStyle(
                            color: AppColors.blackGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.03),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoBox(
                        leadingText: 'Ano:',
                        text: movie.releaseDate.year.toString(),
                      ),

                      // PRECISA ADICIONAR DURATION DINÂMICO
                      InfoBox(
                        leadingText: 'Duração:',
                        text: _getDuration(movie.runtime),
                        // text: movie.duration,
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                    child: Row(
                      children: movie.genres
                          .map((g) => Container(
                                margin: EdgeInsets.only(right: 15),
                                child: GenreBox(
                                  text: g.name,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.03),
                  child:
                      DescriptionText(title: 'Descrição', text: movie.overview),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.02),
                  width: deviceSize.width,
                  child: InfoBox(
                    leadingText: 'ORÇAMENTO:',
                    text: '\$' + currencyFormat.format(movie.budget),
                  ),
                ),

                // PRECISA ADICIONAR PRODUTORAS DINÂMICO
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                  width: deviceSize.width,
                  child: InfoBox(
                    leadingText: 'PRODUTORAS:',
                    text: _getListString(
                        _getCompanyName(movie.productionCompanies)),
                  ),
                ),

                // FALTA
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                  child: DescriptionText(
                    title: 'DIRETOR',
                    text: _getListString(_getDirectorName(credits!.crew)),
                  ),
                ),

                // FALTA
                Container(
                  child: DescriptionText(
                    title: 'ELENCO',
                    text: _getListString(_getCastName(credits.cast)),
                  ),
                ),
              ],
            ),
          ),

          // Positioned(
          //   top: 50,
          //   left: 30,
          //   child: BackButton(),
          // )
        ],
      ),
    );
  }

  String _getDuration(int duration) {
    if (duration == 0) {
      return '-';
    }

    Duration d = Duration(minutes: duration);
    List<String> time = d.toString().split(':');
    return '${time[0]}h ${time[1]} min';
  }

  String _getListString(List<String> list) {
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

  List<String> _getCompanyName(List<ProductionCompanyModel> listCompany) {
    List<String> list = [];

    listCompany.forEach((company) {
      list.add(company.name);
    });

    return list;
  }

  List<String> _getDirectorName(List<Crew> crew) {
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

  List<String> _getCastName(List<Cast> cast) {
    List<String> list = [];

    // ADICIONA À LISTA
    cast.forEach((c) {
      list.add(c.name);
    });

    return list;
  }
}
