import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_detail.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:cubos_movies/view/utils/constansts.dart';
import 'package:cubos_movies/view/utils/utils.dart';
import 'package:cubos_movies/view_model/details_view_model.dart';
import 'package:cubos_movies/view_model/movie_view_model.dart';
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
  final MovieDetailViewModel viewModel =
      MovieDetailViewModel(MovieRepository());
  final currencyFormat = new NumberFormat('###,###,###');

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    viewModel.fetchMovieDetailsData(widget.movieId);
    viewModel.apiResponse.addListener(() {
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
    ApiResponse apiResponse = viewModel.response;

    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());

      case Status.COMPLETED:
        return buildMovieDetail(apiResponse);

      case Status.ERROR:
        return Center(
          child: Text('Please try again Later !!'),
        );

      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search the Movie'),
        );
    }
  }

  Widget buildMovieDetail(ApiResponse apiResponse) {
    MovieDetail? movie = apiResponse.data as MovieDetail?;
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
                  width: deviceSize.width * 0.6,
                  height: deviceSize.height * 0.7,
                  child: Center(
                    child: Hero(
                      tag: widget.movieId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: TmdbConstants.imageBase + movie!.backdropPath,
                          fit: BoxFit.fill,
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
                        text: '1h 20 min',
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: movie.genres
                          .map((g) => GenreBox(
                                text: g.name,
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
                    text: 'Marvel studios',
                  ),
                ),

                // FALTA
                Container(
                  margin: EdgeInsets.only(bottom: deviceSize.height * 0.05),
                  child: DescriptionText(
                    title: 'DIRETOR',
                    text: '',
                  ),
                ),

                // FALTA
                Container(
                  child: DescriptionText(
                    title: 'ELENCO',
                    text: '',
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
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: deviceSize.width * 0.25,
        height: deviceSize.height * 0.066,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.3,
              blurRadius: 3,
              offset: Offset(0, 0.5), // changes position of shadow
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF7b7e7e),
              size: 13.54,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Voltar',
              style: TextStyle(color: Color(0xFF7b7e7e), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  InfoBox({
    required this.leadingText,
    required this.text,
  });

  final String leadingText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            leadingText,
            style: TextStyle(
              color: AppColors.mediumGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              ' $text',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class GenreBox extends StatelessWidget {
  GenreBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mediumGrey, width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: AppColors.mediumGrey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  DescriptionText({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.mediumGrey,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text(
            text,
            style: TextStyle(
              color: AppColors.mediumGrey,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
