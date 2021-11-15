import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_details.dart';
import 'package:cubos_movies/view/utils/utils.dart';
import 'package:cubos_movies/view/widgets/custom_silver_delegate.dart';
import 'package:cubos_movies/view_model/movie_view_model.dart';
import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  MovieDetailsScreen({required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieViewModel viewModel = MovieViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.fetchMovieDetailsData(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.whiteSmoke,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 80.0,
                height: 32.0,
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
                      color: AppColors.textDark,
                      size: 13.54,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Voltar',
                      style: TextStyle(color: AppColors.textDark, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: loadMovieDetail(),
    );
  }

  Widget loadMovieDetail() {
    ApiResponse apiResponse = viewModel.response;

    switch (apiResponse.status) {
      case Status.LOADING:
        {
          return Center(child: CircularProgressIndicator());
        }

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
    MovieDetails? movie = apiResponse.data as MovieDetails?;
    return Text(movie!.belongsToCollection.name);
  }
}
