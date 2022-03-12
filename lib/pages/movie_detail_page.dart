import 'package:cubos_movies/components/details_page/hero_poster_components.dart';
import 'package:cubos_movies/controllers/movie_detail_controller.dart';
import 'package:cubos_movies/core/app_colors.dart';
import 'package:cubos_movies/core/app_constants.dart';
import 'package:cubos_movies/model/%20movie_credits.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository_imp.dart';
import 'package:cubos_movies/service/dio_service_imp.dart';
import 'package:cubos_movies/widgets/description_text.dart';
import 'package:cubos_movies/widgets/genre_box.dart';
import 'package:cubos_movies/widgets/info_box.dart';
import 'package:cubos_movies/widgets/centered_message.dart';
import 'package:cubos_movies/widgets/centered_progress.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final _controller = MovieDetailController(
    MoviesRepositoryImp(
      DioServiceImp(),
    ),
  );

  @override
  void initState() {
    super.initState();
    this._initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Future<void> _initialize() async {
    await _controller.fetchMovieById(widget.movieId);
    await _controller.fetchMovieCredits(widget.movieId);
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller.movieResponseApi,
        _controller.movieCreditsResponseApi,
        _controller.loadingApi,
        _controller.movieErrorApi,
      ]),
      builder: (_, __) {
        if (_controller.loading) {
          return CenteredProgress();
        }

        if (_controller.movieError != null) {
          return CenteredMessage(message: _controller.movieError!.message!);
        }

        return buildMovieDetail();
      },
    );
  }

  Widget buildMovieDetail() {
    MovieDetailModel movie = _controller.movieDetail!;
    MovieCredits credits = _controller.movieCredits!;

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
                HeroPosterComponents(
                    deviceSize: deviceSize, widget: widget, movie: movie),
                _buildVotesMovie(deviceSize, movie),
                _buildMovieTitle(deviceSize, movie),
                _buildOriginalTitle(deviceSize, movie),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.03),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoBox(
                        leadingText: 'Year:',
                        text: movie.releaseDate!.year.toString(),
                      ),
                      InfoBox(
                        leadingText: 'Duration:',
                        text: _controller.getDuration(movie.runtime!),
                        // text: movie.duration,
                      ),
                    ],
                  ),
                ),
                _buildMovieGenres(deviceSize, movie),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.03),
                  child: DescriptionText(
                      title: 'Description', text: movie.overview!),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.02),
                  width: deviceSize.width,
                  child: InfoBox(
                    leadingText: 'BUDGET:',
                    text:
                        '\$' + AppConstants.currencyFormat.format(movie.budget),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                  width: deviceSize.width,
                  child: InfoBox(
                    leadingText: 'PRODUCERS:',
                    text: _controller.getListString(
                        _controller.getCompanyName(movie.productionCompanies!)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                  child: DescriptionText(
                    title: 'DIRECTOR',
                    text: _controller.getListString(
                        _controller.getDirectorName(credits.crew)),
                  ),
                ),
                Container(
                  child: DescriptionText(
                    title: 'CAST',
                    text: _controller
                        .getListString(_controller.getCastName(credits.cast)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildMovieGenres(
      Size deviceSize, MovieDetailModel movie) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
        child: Row(
          children: movie.genres!
              .map((g) => Container(
                    margin: EdgeInsets.only(right: 15),
                    child: GenreBox(
                      text: g.name!,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Container _buildOriginalTitle(Size deviceSize, MovieDetailModel movie) {
    return Container(
      margin: EdgeInsets.only(bottom: deviceSize.height * 0.06),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Original Title: ",
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
    );
  }

  Container _buildMovieTitle(Size deviceSize, MovieDetailModel movie) {
    return Container(
      margin: EdgeInsets.only(bottom: deviceSize.height * 0.04),
      child: Text(
        movie.title!.toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textDark),
        textAlign: TextAlign.center,
      ),
    );
  }

  Column _buildVotesMovie(Size deviceSize, MovieDetailModel movie) {
    return Column(
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
    );
  }
}
