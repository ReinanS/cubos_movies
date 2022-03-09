import 'package:cubos_movies/controllers/movie_detail_controller.dart';
import 'package:cubos_movies/core/app_colors.dart';
import 'package:cubos_movies/core/app_constants.dart';
import 'package:cubos_movies/model/%20movie_credits.dart';
import 'package:cubos_movies/model/movie_detail_model.dart';
import 'package:cubos_movies/repositories/movies/movies_repository_imp.dart';
import 'package:cubos_movies/service/dio_service_imp.dart';
import 'package:cubos_movies/utils/api.utils.dart';
import 'package:cubos_movies/view/widgets/description_text.dart';
import 'package:cubos_movies/view/widgets/genre_box.dart';
import 'package:cubos_movies/view/widgets/info_box.dart';
import 'package:cubos_movies/widgets/centered_message.dart';
import 'package:cubos_movies/widgets/centered_progress.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
      body: _background(
        child: _body(),
      ),
    );
  }

  Future<void> _initialize() async {
    _controller.fetchMovieById(widget.movieId);
    _controller.fetchMovieCredits(widget.movieId);
  }

  Widget _body() {
    return Container(
      child: Text(widget.movieId.toString()),
    );
  }

  Widget _background({required Widget child}) {
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
                          image: API.requestImage(movie.posterPath!),
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
                    movie.title!.toUpperCase(),
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
                        text: movie.releaseDate!.year.toString(),
                      ),
                      InfoBox(
                        leadingText: 'Duração:',
                        text: _controller.getDuration(movie.runtime!),
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
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.03),
                  child: DescriptionText(
                      title: 'Descrição', text: movie.overview!),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.02),
                  width: deviceSize.width,
                  child: InfoBox(
                    leadingText: 'ORÇAMENTO:',
                    text:
                        '\$' + AppConstants.currencyFormat.format(movie.budget),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                  width: deviceSize.width,
                  child: InfoBox(
                    leadingText: 'PRODUTORAS:',
                    text: _controller.getListString(
                        _controller.getCompanyName(movie.productionCompanies!)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                  child: DescriptionText(
                    title: 'DIRETOR',
                    text: _controller.getListString(
                        _controller.getDirectorName(credits.crew)),
                  ),
                ),
                Container(
                  child: DescriptionText(
                    title: 'ELENCO',
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
}
