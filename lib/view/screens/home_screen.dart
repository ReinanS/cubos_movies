import 'dart:developer';

import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/repository/movie_repository.dart';
import 'package:cubos_movies/view/widgets/genres_tab_widget.dart';
import 'package:cubos_movies/view_model/genre_view_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GenreViewModel genreViewModel = GenreViewModel(MovieRepository());

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    genreViewModel.fetchGenresList();
    genreViewModel.apiResponse.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse apiGenreResponse = genreViewModel.response;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Filmes', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: _getGenres(apiGenreResponse));
  }

  Widget _getGenres(ApiResponse apiGenreResponse) {
    List<MovieGenre>? genreList = apiGenreResponse.data as List<MovieGenre>?;

    switch (apiGenreResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());

      case Status.COMPLETED:
        return GenresTabWidget(genres: genreList!);

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
}
